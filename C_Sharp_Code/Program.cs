using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using MySql.Data;
using MySql.Data.MySqlClient;
using System.Collections;
using System.Data.OleDb;



namespace Project
{
    class Program
    {
        static public Hashtable hshTable = new Hashtable();
        static public void excute(int Short_Stretch_ID,float Energy, float Energy_Vdw, float Energy_SolvH, float Energy_SolvP, float Energy_Vdwclash, float Sidechain_Burial ,float Mainchain_Burial)
        {
            string ConString = "SERVER=localhost;" +
           "DATABASE=aggreation_db;" +
           "UID=root;" +
           "PASSWORD=mahmoud;";
            MySqlConnection conn = new MySqlConnection(ConString);
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(ConString, conn);
            cmd.CommandText = "INSERT INTO aggreation_db.foldx_sequencedetail(Short_Stretch_ID, energy, energy_VDW, energy_SolvH, energy_SolvP, energy_vdwclash, sidechain_burial, mainchain_burial) "
            + "VALUES (@Short_Stretch_ID, @energy, @energy_VDW, @energy_SolvH, @energy_SolvP, @energy_vdwclash, @sidechain_burial, @mainchain_burial)";
            cmd.Parameters.AddWithValue("@Short_Stretch_ID", Short_Stretch_ID);
            cmd.Parameters.AddWithValue("@energy", Energy);
            cmd.Parameters.AddWithValue("@energy_VDW", Energy_Vdw);
            cmd.Parameters.AddWithValue("@energy_SolvH", Energy_SolvH);
            cmd.Parameters.AddWithValue("@energy_SolvP", Energy_SolvP);
            cmd.Parameters.AddWithValue("@energy_vdwclash", Energy_Vdwclash);
            cmd.Parameters.AddWithValue("@sidechain_burial", Sidechain_Burial);
            cmd.Parameters.AddWithValue("@mainchain_burial", Mainchain_Burial);
            cmd.ExecuteNonQuery();
            conn.Close();
        }
        static public void Insert_Proteins()
        {
            string Protein_line;
            string Global_line;
            int FirstLine = 0;
            string MyConString = "SERVER=localhost;" +
            "DATABASE=aggreation_db;" +
            "UID=root;" +
            "PASSWORD=mahmoud;";
            MySqlConnection connection = new MySqlConnection(MyConString);
            connection.Open();

            using (StreamReader Protein_file = new StreamReader(@"D:\Master of Bioinformatics\Ubuntu\Data_Set\Proteins_Names.txt"))
            {

                while ((Protein_line = Protein_file.ReadLine()) != null)
                {
                    using (StreamReader Global_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_line + "/WT/PSX_globaltotal.out"))
                    {
                        while ((Global_line = Global_file.ReadLine()) != null)
                        {
                            if (FirstLine == 1)
                            {
                                Proteins protein = new Proteins();
                                char[] delimiters = new char[] { '\t' };
                                string[] parts = Global_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                char[] delimiters_2 = new char[] { '_' };
                                string[] parts_2 = parts[0].Split(delimiters_2, StringSplitOptions.RemoveEmptyEntries);
                                protein.Uniprot_ID = parts_2[0];
                                protein.Protein_Name = parts_2[1];
                                if (parts[2].Equals("-nan"))
                                {
                                    protein.Tango = 0;
                                }
                                else
                                {
                                    protein.Tango = float.Parse(parts[2]);
                                }
                                if (parts[3].Equals("-nan"))
                                {
                                    protein.Waltz = 0;
                                }
                                else
                                {
                                    protein.Waltz = float.Parse(parts[3]);
                                }
                                if (parts[5].Equals("-nan"))
                                {
                                    protein.Agadir = 0;
                                }
                                else
                                {
                                    protein.Agadir = float.Parse(parts[5]);
                                }
                                if (parts[6].Equals("-nan"))
                                {
                                    protein.Limbo = 0;
                                }
                                else
                                {
                                    protein.Limbo = float.Parse(parts[6]);
                                }

                                MySqlCommand cmd = new MySqlCommand("", connection);
                                cmd.CommandText = "INSERT INTO aggreation_db.proteins(uniprot_ID, Protein_Name, PDB_ID, TANGO, Waltz, Agadir, LIMBO) "
                                + "VALUES (@uniprot_ID, @Protein_Name, @PDB_ID, @TANGO, @Waltz, @Agadir, @LIMBO)";
                                cmd.Parameters.AddWithValue("@uniprot_ID", protein.Uniprot_ID);
                                cmd.Parameters.AddWithValue("@Protein_Name", protein.Protein_Name);
                                cmd.Parameters.AddWithValue("@PDB_ID", protein.PDB_ID);
                                cmd.Parameters.AddWithValue("@TANGO", protein.Tango);
                                cmd.Parameters.AddWithValue("@Waltz", protein.Waltz);
                                cmd.Parameters.AddWithValue("@Agadir", protein.Agadir);
                                cmd.Parameters.AddWithValue("@LIMBO", protein.Limbo);
                                cmd.ExecuteNonQuery();
                                Console.WriteLine("The Protein " + Protein_line + " is succesfully inserted");

                            }

                            FirstLine++;
                        }
                        Global_file.Close();
                        FirstLine = 0;
                    }

                }
                Protein_file.Close();
            }
            // Suspend the screen.
            connection.Close();
            Console.ReadLine();
        }
        static public void Insert_Sequences(string Protein_Name)
        {
            string Mutants_line;
            string Global_line;
            string Foldx_line;
            string BLOSUM62_line;
            string BLOSUM45_line;
            string BLOSUM80_line;
            string SIFT_line;
            string CONSURF_line;
            string Note_line;
            string WT_line;
            string Protein_ID;
            string Mapping_line;
            string individual_list_line;
            string PDB_Mapping_line;
            string PDB_ID="";
            int Modified_Pos = 0;
            int PDB_Start = 0;
            int PDB_End = 0;
            int Uniprot_Start = 0;
            int Uniprot_End = 0;
            int Modified_Start = 0;
            int Modified_End = 0;
            string Secondary_Structure_line;
            int FirstLine = 0;
            int File_Counter = 10;
            int File_Counter2 = 10;
            string MyConString = "SERVER=localhost;" +
            "DATABASE=aggreation_db;" +
            "UID=root;" +
            "PASSWORD=mahmoud;";
            MySqlConnection connection = new MySqlConnection(MyConString);
            connection.Open();

            string F1Name = "D:\\Master of Bioinformatics\\Ubuntu\\Data_Set\\Final_mutants.xls";
            string CnStr = ("Provider=Microsoft.Jet.OLEDB.4.0;" + ("Data Source="
            + (F1Name + (";" + "Extended Properties=\"Excel 8.0;\""))));

            DataSet ds = new DataSet();
            OleDbDataAdapter DA = new OleDbDataAdapter("Select * from [Sheet1$]", CnStr);
            DA.Fill(ds, "srlno");

            using (StreamReader Mutants_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/Mutants_List.txt"))
            {

                while ((Mutants_line = Mutants_file.ReadLine()) != null)
                {
                    using (StreamReader Global_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/PSX_globaltotal.out"))
                    {
                        while ((Global_line = Global_file.ReadLine()) != null)
                        {
                            Sequences sequecne = new Sequences();
                            sequecne.Orignial_AA = Mutants_line.Substring(0, 1);
                            sequecne.Position = int.Parse(Mutants_line.Substring(1, Mutants_line.Length - 2));
                            sequecne.Mutant = Mutants_line.Substring(Mutants_line.Length - 1);
                            if (FirstLine == 1)
                            {

                                char[] delimiters = new char[] { '\t' };
                                string[] parts = Global_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);

                                if (parts[2].Equals("-nan"))
                                {
                                    sequecne.Tango = 0;
                                }
                                else
                                {
                                    sequecne.Tango = float.Parse(parts[2]);
                                }
                                if (parts[3].Equals("-nan"))
                                {
                                    sequecne.Waltz = 0;
                                }
                                else
                                {
                                    sequecne.Waltz = float.Parse(parts[3]);
                                }
                                if (parts[5].Equals("-nan"))
                                {
                                    sequecne.Agadir = 0;
                                }
                                else
                                {
                                    sequecne.Agadir = float.Parse(parts[5]);
                                }
                                if (parts[6].Equals("-nan"))
                                {
                                    sequecne.Limbo = 0;
                                }
                                else
                                {
                                    sequecne.Limbo = float.Parse(parts[6]);
                                }

                                using (StreamReader WT_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/WT/" + Protein_Name + "_WT.fasta"))
                                {
                                    WT_line = WT_file.ReadLine();
                                    char[] delimiters_2 = new char[] { '_' };
                                    string[] WT_parts = WT_line.Split(delimiters_2, StringSplitOptions.RemoveEmptyEntries);
                                    Protein_ID = WT_parts[0].Substring(1, WT_parts[0].Length - 1);
                                    sequecne.Protein_ID = Protein_ID;
                                    WT_file.Close();
                                }

                                MySqlCommand command = connection.CreateCommand();
                                MySqlDataReader Reader;
                                command.CommandText = "select * from aggreation_db.proteins where uniprot_ID = '" + Protein_ID + "'";
                                //connection.Open();
                                Reader = command.ExecuteReader();
                                while (Reader.Read())
                                {
                                        PDB_ID = Reader.GetValue(3).ToString();
                                        sequecne.dTango = sequecne.Tango - float.Parse(Reader.GetValue(4).ToString());
                                        sequecne.dWaltz = sequecne.Waltz - float.Parse(Reader.GetValue(5).ToString());
                                        sequecne.dAgadir = sequecne.Agadir - float.Parse(Reader.GetValue(6).ToString());
                                        sequecne.dLimbo = sequecne.Limbo - float.Parse(Reader.GetValue(7).ToString());

                                }
                                Reader.Close();

                                char[] delimiters_4 = new char[] { '_' };
                                string[] PDB_ID_ARR = PDB_ID.Split(delimiters_4, StringSplitOptions.RemoveEmptyEntries);
                                if (PDB_ID_ARR.Length > 1)
                                {
                                    string[] Mapping_line_parts;
                                    using (StreamReader Mapping_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Mapping.txt"))
                                    {

                                        while ((Mapping_line = Mapping_file.ReadLine()) != null)
                                        {
                                            if (Mapping_line.Contains(Mutants_line))
                                            {
                                               Mapping_line_parts = Mapping_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                               PDB_ID=Mapping_line_parts[1];
                                            }
                                        }
                                    }

                                    using (StreamReader PDB_Mapping_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/pdb_chain_uniprot.lst.txt"))
                                    {//
                                        while ((PDB_Mapping_line = PDB_Mapping_file.ReadLine()) != null)
                                        {
                                            string[] PDB_Mapping_line_parts = PDB_Mapping_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                            // if (Mapping_line_parts[0].Equals(PDB_ID) && Mapping_line_parts[2].Equals(Protein_ID))
                                            if (string.Compare(PDB_Mapping_line_parts[0], PDB_ID, true) == 0 && string.Compare(PDB_Mapping_line_parts[2], Protein_ID, true) == 0)
                                            {
                                                PDB_Start = int.Parse(PDB_Mapping_line_parts[5]);
                                                PDB_End = int.Parse(PDB_Mapping_line_parts[6]);
                                                Uniprot_Start = int.Parse(PDB_Mapping_line_parts[7]);
                                                Uniprot_End = int.Parse(PDB_Mapping_line_parts[8]);

                                                Modified_Pos = int.Parse(Mutants_line.Substring(1, Mutants_line.Length - 2)) - Uniprot_Start + PDB_Start;
                                                
                                            }
                                        }
                                    }



                                    if (File.Exists("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Note.txt"))
                                    {
                                        bool flag=false;
                                        using (StreamReader Note_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Note.txt"))
                                        {
                                            
                                            while ((Note_line = Note_file.ReadLine()) != null)
                                            {

                                                string[] Note_line_parts = Note_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                                if (Note_line.Contains("Based"))
                                                {
                                                    if (string.Compare(PDB_ID, Note_line_parts[1].Substring(0, 4), true) == 0)
                                                    {
                                                        flag = true;
                                                    }

                                                }
                                                if(Note_line.Contains("Residue range") && flag)
                                                {
                                                    char[] delimiters_5 = new char[] { ' ' };
                                                    string[] res_line_parts = Note_line_parts[1].Split(delimiters_5, StringSplitOptions.RemoveEmptyEntries);
                                                    PDB_Start = int.Parse(res_line_parts[0]);
                                                    PDB_End = int.Parse(res_line_parts[2]);
                                                    Uniprot_Start = PDB_Start;
                                                    Uniprot_End = PDB_End;
                                                    Modified_Pos = int.Parse(Mutants_line.Substring(1, Mutants_line.Length - 2)) - Uniprot_Start + PDB_Start;
                                                }
                                            }
                                        }
                                        
                                    }

                                    int list_line_count = 0;
                                    using (StreamReader individual_list_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Mutate Residue_" + PDB_ID + "/individual_list.txt"))
                                    {
                                       
                                        while ((individual_list_line = individual_list_file.ReadLine()) != null)
                                        {
                                            list_line_count++;
                                            if (string.Compare(individual_list_line.Substring(0, 1) + individual_list_line.Substring(2,individual_list_line.Length-3), Mutants_line.Substring(0,1) + Modified_Pos.ToString() + Mutants_line.Substring(Mutants_line.Length - 1,1) ,true) == 0 )
                                            {
                                                File_Counter2 = list_line_count;
                                            }
                                          
                                        }

                                    }


                                    var File_Length = File.ReadAllLines("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Mutate Residue_" + PDB_ID + "/Average_BuildModel_" + PDB_ID + ".fxout").Length;
                                    using (StreamReader Foldx_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Mutate Residue_" + PDB_ID + "/Average_BuildModel_" + PDB_ID + ".fxout"))
                                        {
                                            int line = 1;
                                            while ((Foldx_line = Foldx_file.ReadLine()) != null)
                                            {
                                                if (line >= 10)
                                                {
                                                    string[] Foldx_line_parts = Foldx_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                                    if (Foldx_line_parts[0].Equals(PDB_ID + "_" + File_Counter2))
                                                    {
                                                        if (Math.Abs(float.Parse(Foldx_line_parts[9])) >= 0.5)
                                                        {
                                                            sequecne.ddG = float.Parse(Foldx_line_parts[2]) + float.Parse(Foldx_line_parts[9]);
                                                        }
                                                        else
                                                        {
                                                            sequecne.ddG = float.Parse(Foldx_line_parts[2]);
                                                        }
                                                    }
                                                }
                                                line++;
                                            }
                                           
                                        }
                                    
                                    
                                }
                                else
                                {
                                    var File_Length = File.ReadAllLines("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Mutate Residue_" + PDB_ID + "/Average_BuildModel_" + PDB_ID + ".fxout").Length;
                                    using (StreamReader Foldx_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Mutate Residue_" + PDB_ID + "/Average_BuildModel_" + PDB_ID + ".fxout"))
                                    {
                                        int line = 1;
                                        while ((Foldx_line = Foldx_file.ReadLine()) != null)
                                        {
                                            if (line == File_Counter && File_Counter <= File_Length)
                                            {
                                                string[] Foldx_line_parts = Foldx_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                                if (Math.Abs(float.Parse(Foldx_line_parts[9])) >= 0.5)
                                                {
                                                    sequecne.ddG = float.Parse(Foldx_line_parts[2]) + float.Parse(Foldx_line_parts[9]);
                                                }
                                                else
                                                {
                                                    sequecne.ddG = float.Parse(Foldx_line_parts[2]);
                                                }
                                            }
                                            line++;
                                        }
                                        
                                    }
                                }

                                File_Counter++;
                                

                                using (StreamReader BLOSUM62_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/BLOSUM62.txt"))
                                {
                                    while ((BLOSUM62_line = BLOSUM62_file.ReadLine()) != null)
                                    {
                                        sequecne.BLOSUM62 = float.Parse(BLOSUM62_line);
                                    }
                                    BLOSUM62_file.Close();
                                }
                                using (StreamReader BLOSUM45_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/BLOSUM45.txt"))
                                {
                                    while ((BLOSUM45_line = BLOSUM45_file.ReadLine()) != null)
                                    {
                                        sequecne.BLOSUM45 = float.Parse(BLOSUM45_line);
                                    }
                                    BLOSUM45_file.Close();
                                }

                                using (StreamReader BLOSUM80_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/BLOSUM80.txt"))
                                {
                                    while ((BLOSUM80_line = BLOSUM80_file.ReadLine()) != null)
                                    {
                                        sequecne.BLOSUM80 = float.Parse(BLOSUM80_line);
                                    }
                                    BLOSUM80_file.Close();
                                }



                                try
                                {
                                   
                                    foreach (DataRow dr in ds.Tables["srlno"].Rows)
                                    {
                                        if(Mutants_line.Equals(dr[3].ToString().Trim()) && Protein_ID.Equals(dr[2].ToString().Trim()))
                                        {
                                            sequecne.Aggregate = dr[4].ToString();
                                        }

                                    }
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine(ex.Message);
                                }
                                DA.Dispose();

                                if (!Protein_Name.Equals("PAH"))
                                {// coz I missing the sift file for this protein
                                    using (StreamReader SIFT_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/Score_" + Mutants_line + ".txt"))
                                    {
                                        while ((SIFT_line = SIFT_file.ReadLine()) != null)
                                        {
                                            sequecne.SIFT = float.Parse(SIFT_line);
                                        }
                                        SIFT_file.Close();
                                    }

                                }
                                using (StreamReader CONSURF_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/Consurf_" + Mutants_line + ".txt"))
                                {
                                    while ((CONSURF_line = CONSURF_file.ReadLine()) != null)
                                    {

                                        char[] delimiters_2 = new char[] { ' ' };
                                        string[] CONSURF_line_parts = CONSURF_line.Split(delimiters_2, StringSplitOptions.RemoveEmptyEntries);
                                        sequecne.Consurf_Score=float.Parse(CONSURF_line_parts[0]);
                                        if (CONSURF_line_parts[1].Contains("*"))
                                        {
                                            sequecne.Consurf_Color = int.Parse(CONSURF_line_parts[1].Substring(0,CONSURF_line_parts[1].Length - 1));
                                        }
                                        else
                                        {
                                            sequecne.Consurf_Color = int.Parse(CONSURF_line_parts[1]);
                                        }
                                        if (CONSURF_line_parts.Length == 4)
                                        {
                                            sequecne.Consurf_B_E = CONSURF_line_parts[2];
                                            sequecne.Consurf_Function = CONSURF_line_parts[3];

                                        }
                                        else if (CONSURF_line_parts.Length == 3)
                                        {
                                            if (CONSURF_line_parts[2].Equals("b") || CONSURF_line_parts[2].Equals("e"))
                                            {
                                                sequecne.Consurf_B_E = CONSURF_line_parts[2];
                                                sequecne.Consurf_Function = "";
                                            }
                                            else if (CONSURF_line_parts[2].Equals("f") || CONSURF_line_parts[2].Equals("s"))
                                            {
                                                sequecne.Consurf_Function = CONSURF_line_parts[2];
                                            }
                                        }
                                        //sequecne.SIFT = float.Parse(CONSURF_line);
                                    }
                                    CONSURF_file.Close();
                                }

                                var WT_lineCount = File.ReadAllLines("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name +  "/WT/PSX_tangowindow.out").Length - 1;
                                var Mutant_lineCount = File.ReadAllLines("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/PSX_tangowindow.out").Length - 1;
                                sequecne.Gain_Loss_Tango = Mutant_lineCount - WT_lineCount;

                                int line_count=0;
                                using (StreamReader Secondary_Structure_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/Secondary_Structure.txt"))
                                {

                                    while ((Secondary_Structure_line = Secondary_Structure_file.ReadLine()) != null)
                                    {
                                        line_count++;
                                        if (Secondary_Structure_line.Contains('\t'))
                                        {
                                            string[] Secondary_Structure_line_parts = Secondary_Structure_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                            char[] delimiters_3 = new char[] { ' ' };
                                            string[] start_end_parts = Secondary_Structure_line_parts[1].Split(delimiters_3, StringSplitOptions.RemoveEmptyEntries);
                                            if (sequecne.Position >= int.Parse(start_end_parts[0]) && sequecne.Position <= int.Parse(start_end_parts[2]))
                                            {
                                                sequecne.Secondary_Structure = Secondary_Structure_line_parts[0];
                                            }
                                        }
                                        else if (Secondary_Structure_line.Length > 50 && line_count == 2)
                                        {
                                            string structure=Secondary_Structure_line.Substring(sequecne.Position - 1, 1);
                                            if (structure.Equals("E"))
                                            {
                                                sequecne.Secondary_Structure = "Beta strand";
                                            }
                                            else if (structure.Equals("H"))
                                            {
                                                sequecne.Secondary_Structure = "Helix";
                                            }
                                            else if (structure.Equals("-"))
                                            {
                                                sequecne.Secondary_Structure = "loop";
                                            }

                                        }
                                    }
                                    if (sequecne.Secondary_Structure == null)
                                    {
                                        sequecne.Secondary_Structure = "loop";
                                    }
                                    Secondary_Structure_file.Close();
                                }
                                ;
                                MySqlCommand cmd = new MySqlCommand("", connection);
                                cmd.CommandText = "INSERT INTO aggreation_db.sequences(Protein_ID, ORAA, pos, Mutant, Tango, Waltz, Agadir, LIMBO, dTango, dWaltz, dAgadir, dLIMBO, BLOSUM62, BLOSUM45, BLOSUM80, SIFT, Secondary_Structure, Gain_Loss_Tango, Consurf_Score, Consurf_Color, Consurf_B_E, Consurf_Function, ddG, Aggregate)"
                                + "VALUES (@Protein_ID, @ORAA, @pos, @Mutant, @Tango, @Waltz, @Agadir, @LIMBO, @dTango, @dWaltz, @dAgadir, @dLIMBO, @BLOSUM62, @BLOSUM45, @BLOSUM80, @SIFT, @Secondary_Structure, @Gain_Loss_Tango, @Consurf_Score, @Consurf_Color, @Consurf_B_E, @Consurf_Function, @ddG, @Aggregate)";
                                cmd.Parameters.AddWithValue("@Protein_ID", sequecne.Protein_ID);
                                cmd.Parameters.AddWithValue("@ORAA", sequecne.Orignial_AA);
                                cmd.Parameters.AddWithValue("@pos", sequecne.Position);
                                cmd.Parameters.AddWithValue("@Mutant", sequecne.Mutant);
                                cmd.Parameters.AddWithValue("@TANGO", sequecne.Tango);
                                cmd.Parameters.AddWithValue("@Waltz", sequecne.Waltz);
                                cmd.Parameters.AddWithValue("@Agadir", sequecne.Agadir);
                                cmd.Parameters.AddWithValue("@LIMBO", sequecne.Limbo);
                                cmd.Parameters.AddWithValue("@dTANGO", sequecne.dTango);
                                cmd.Parameters.AddWithValue("@dWaltz", sequecne.dWaltz);
                                cmd.Parameters.AddWithValue("@dAgadir", sequecne.dAgadir);
                                cmd.Parameters.AddWithValue("@dLIMBO", sequecne.dLimbo);
                                cmd.Parameters.AddWithValue("@BLOSUM62", sequecne.BLOSUM62);
                                cmd.Parameters.AddWithValue("@BLOSUM45", sequecne.BLOSUM45);
                                cmd.Parameters.AddWithValue("@BLOSUM80", sequecne.BLOSUM80);
                                cmd.Parameters.AddWithValue("@SIFT", sequecne.SIFT);
                                cmd.Parameters.AddWithValue("@Secondary_Structure", sequecne.Secondary_Structure);
                                cmd.Parameters.AddWithValue("@Gain_Loss_Tango", sequecne.Gain_Loss_Tango);
                                cmd.Parameters.AddWithValue("@Consurf_Score", sequecne.Consurf_Score);
                                cmd.Parameters.AddWithValue("@Consurf_Color", sequecne.Consurf_Color);
                                cmd.Parameters.AddWithValue("@Consurf_B_E", sequecne.Consurf_B_E);
                                cmd.Parameters.AddWithValue("@Consurf_Function", sequecne.Consurf_Function);
                                cmd.Parameters.AddWithValue("@ddG", sequecne.ddG);
                                cmd.Parameters.AddWithValue("@Aggregate", sequecne.Aggregate);
                                cmd.ExecuteNonQuery();
                                Console.WriteLine("The Mutant " + Mutants_line + " of protein " + Protein_Name + " is succesfully inserted");
                            }

                            FirstLine++;
                        }
                        Global_file.Close();
                        FirstLine = 0;
                    }

                }
                Mutants_file.Close();
            }
            // Suspend the screen.
            connection.Close();
          
        }
        static public void Insert_Domain(string Protein_Name)
        {
            Domain PFAM_domain = new Domain();
            Domain SMART_domain = new Domain();
            string PFAM_line;
            string SMART_line;
            string MyConString = "SERVER=localhost;" +
           "DATABASE=aggreation_db;" +
           "UID=root;" +
           "PASSWORD=mahmoud;";
            MySqlConnection connection = new MySqlConnection(MyConString);
            connection.Open();
            string[] Protein_ID_tmp = Directory.GetFiles("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/PFAM/", "*.txt").Select(path => Path.GetFileName(path)).ToArray();
            char[] delimiters_2 = new char[] { '_' };
            string[] Protein_ID_tmp_parts = Protein_ID_tmp[0].Split(delimiters_2, StringSplitOptions.RemoveEmptyEntries);
            string Protein_ID = Protein_ID_tmp_parts[1].Substring(0, Protein_ID_tmp_parts[1].Length - 4);
            using (StreamReader PFAM_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/PFAM/PFAM_" + Protein_ID + ".txt"))
            {
                while ((PFAM_line = PFAM_file.ReadLine()) != null)
                {
                    if (!PFAM_line.Equals(" "))
                    {
                        char[] delimiters = new char[] { '\t' };
                        string[] PFAM_line_parts = PFAM_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                        if (PFAM_line_parts[0].Equals("low_complexity ") || PFAM_line_parts[0].Equals("Source ") || PFAM_line_parts[0].Equals("Source"))
                        {

                        }
                        else
                        {
                            PFAM_domain.Protein_ID = Protein_ID;
                            PFAM_domain.Source = PFAM_line_parts[0];
                            PFAM_domain.Domain_Name = PFAM_line_parts[1];
                            PFAM_domain.Start = int.Parse(PFAM_line_parts[2]);
                            PFAM_domain.End = int.Parse(PFAM_line_parts[3]);

                            MySqlCommand cmd = new MySqlCommand("", connection);
                            cmd.CommandText = "INSERT INTO aggreation_db.domain_information(Protein_ID, Source, Start, End, Domain_Name) "
                            + "VALUES (@Protein_ID, @Source, @Start, @End, @Domain_Name)";
                            cmd.Parameters.AddWithValue("@Protein_ID", PFAM_domain.Protein_ID);
                            cmd.Parameters.AddWithValue("@Source", PFAM_domain.Source);
                            cmd.Parameters.AddWithValue("@Start", PFAM_domain.Start);
                            cmd.Parameters.AddWithValue("@End", PFAM_domain.End);
                            cmd.Parameters.AddWithValue("@Domain_Name", PFAM_domain.Domain_Name);
                            cmd.ExecuteNonQuery();

                            Console.WriteLine("The PFAM Domain " + PFAM_domain.Domain_Name + " of Protein " + Protein_Name + " is succesfully inserted");
                        }
                    }
                }
                PFAM_file.Close();
            }

            using (StreamReader SMART_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/SMART/SMART_" + Protein_ID + ".txt"))
            {
                while ((SMART_line = SMART_file.ReadLine()) != null)
                {
                    if (!SMART_line.Equals(""))
                    {
                        if (!SMART_line.Contains("No domains"))
                        {
                            char[] delimiters = new char[] { '\t' };
                            string[] SMART_line_parts = SMART_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                            if (SMART_line_parts[0].Equals("low complexity") || SMART_line_parts[0].Equals("Name"))
                            {

                            }
                            else
                            {
                                SMART_domain.Protein_ID = Protein_ID;
                                SMART_domain.Source = "SMART";
                                SMART_domain.Domain_Name = SMART_line_parts[0];
                                SMART_domain.Start = int.Parse(SMART_line_parts[1]);
                                SMART_domain.End = int.Parse(SMART_line_parts[2]);

                                MySqlCommand cmd = new MySqlCommand("", connection);
                                cmd.CommandText = "INSERT INTO aggreation_db.domain_information (Protein_ID, Source, Start, End, Domain_Name)"
                                + "VALUES (@Protein_ID, @Source, @Start, @End, @Domain_Name)";
                                cmd.Parameters.AddWithValue("@Protein_ID", SMART_domain.Protein_ID);
                                cmd.Parameters.AddWithValue("@Source", SMART_domain.Source);
                                cmd.Parameters.AddWithValue("@Start", SMART_domain.Start);
                                cmd.Parameters.AddWithValue("@End", SMART_domain.End);
                                cmd.Parameters.AddWithValue("@Domain_Name", SMART_domain.Domain_Name);
                                cmd.ExecuteNonQuery();
                                Console.WriteLine("The SMART Domain " + SMART_domain.Domain_Name + " of Protein " + Protein_Name + " is succesfully inserted");


                            }
                        }
                    }
                }

                SMART_file.Close();
            }

            connection.Close();
           

        }
        static public void Insert_Stretch(string Protein_Name)
        {
            string Mutants_line;
            string Global_line;
            string Residue_line;
            string MyConString = "SERVER=localhost;" +
            "DATABASE=aggreation_db;" +
            "UID=root;" +
            "PASSWORD=mahmoud;";
            MySqlConnection connection = new MySqlConnection(MyConString);
            connection.Open();
            using (StreamReader Mutants_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/Mutants_List.txt"))
            {//Mutation_List file

                while ((Mutants_line = Mutants_file.ReadLine()) != null)
                {
                    Sequences sequence = new Sequences();
                    sequence.Orignial_AA = Mutants_line.Substring(0, 1);
                    sequence.Position = int.Parse(Mutants_line.Substring(1, Mutants_line.Length - 2));
                    sequence.Mutant = Mutants_line.Substring(Mutants_line.Length - 1);

                    char[] delimiters = new char[] { '\t' };
                    float Max = 0;
                    int Line = 0;
                    string[] arry = File.ReadAllLines("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/PSX_tangowindow.out");
                    for (int i = 1; i <= arry.Length - 1; i++)
                    {
                        string[] arry_line_parts = arry[i].Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                        if (float.Parse(arry_line_parts[5]) >= Max)
                        {
                            Max = float.Parse(arry_line_parts[5]);
                            Line = i;
                        }
                    }

                    int file_counter = 0;
                    using (StreamReader Global_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/PSX_tangowindow.out"))
                    {//Tango Window File
                        while ((Global_line = Global_file.ReadLine()) != null)
                        {
                            if(file_counter==Line)
                            {

                            if(!Global_line.Equals(""))
                            {
                                if (!Global_line.Contains("protein name"))
                                {
                                    Short_Stretch stretch = new Short_Stretch();
                                  
                                    string[] Global_line_parts = Global_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                    stretch.Start = int.Parse(Global_line_parts[1]) + 1 ;
                                    stretch.End = int.Parse(Global_line_parts[1]) + int.Parse(Global_line_parts[6]);
                                    stretch.Stretch = Global_line_parts[3];
                                    stretch.Gatekeeper1 = Global_line_parts[2];
                                    stretch.Gatekeeper2 = Global_line_parts[4];
                                    stretch.Score = float.Parse(Global_line_parts[5]);



                                    using (StreamReader Residue_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/" + Mutants_line + "/PSX_globalresidue.out"))
                                    {//Residue Window File
                                        float AUP = 0;
                                        while ((Residue_line = Residue_file.ReadLine()) != null)
                                        {
                                            string[] Residue_line_parts = Residue_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                            if (!Residue_line.Contains("name"))
                                            {
                                                if (int.Parse(Residue_line_parts[1]) >= stretch.Start && int.Parse(Residue_line_parts[1]) <= stretch.End)
                                                {
                                                    AUP += float.Parse(Residue_line_parts[6]);

                                                }
                                            }
                                        }
                                        stretch.Aup_Helical_Content = AUP / (stretch.End - stretch.Start + 1);
                                    }//Residue Window File end

                                    string[] Protein_ID_tmp = Directory.GetFiles("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/PFAM/", "*.txt").Select(path => Path.GetFileName(path)).ToArray();
                                    char[] delimiters_2 = new char[] { '_' };
                                    string[] Protein_ID_tmp_parts = Protein_ID_tmp[0].Split(delimiters_2, StringSplitOptions.RemoveEmptyEntries);
                                    string Protein_ID = Protein_ID_tmp_parts[1].Substring(0, Protein_ID_tmp_parts[1].Length - 4);

                                    MySqlCommand command = connection.CreateCommand();
                                    MySqlDataReader Reader;
                                    command.CommandText = "select Sequence_ID from aggreation_db.sequences where Protein_ID = '" + Protein_ID + "' and ORAA = '" + sequence.Orignial_AA + "' and pos ="+ sequence.Position + " and Mutant = '" + sequence.Mutant + "' ";
                                    //connection.Open();
                                    Reader = command.ExecuteReader();
                                    while (Reader.Read())
                                    {
                                        stretch.Sequence_ID = int.Parse(Reader.GetValue(0).ToString());
                                    }
                                    Reader.Close();
                                    if (sequence.Position < stretch.Start)
                                    {
                                        sequence.Distance_To_Tango = stretch.Start - sequence.Position;
                                    }
                                    else if (sequence.Position > stretch.End)
                                    {
                                        sequence.Distance_To_Tango = sequence.Position - stretch.End;
                                    }
                                    else
                                    {
                                        sequence.Distance_To_Tango = 0;
                                    }
                                    command.CommandText = "UPDATE aggreation_db.sequences set Distance_to_Tango=" + sequence.Distance_To_Tango + " where Sequence_ID=" + stretch.Sequence_ID;
                                    command.ExecuteNonQuery();
                                   
                                   // MySqlCommand cmd = new MySqlCommand("", connection);
                                    command.CommandText = "INSERT INTO aggreation_db.short_stretch(Sequence_ID, Start, End, Aup_Helical_Content, Stretch, Score, Gatekeeper1, Gatekeeper2)"
                                    + "VALUES (@Sequence_ID, @Start, @End, @Aup_Helical_Content, @Stretch, @Score, @Gatekeeper1, @Gatekeeper2)";
                                    command.Parameters.AddWithValue("@Sequence_ID", stretch.Sequence_ID);
                                    command.Parameters.AddWithValue("@Start", stretch.Start);
                                    command.Parameters.AddWithValue("@End", stretch.End);
                                    command.Parameters.AddWithValue("@Aup_Helical_Content", stretch.Aup_Helical_Content);
                                    command.Parameters.AddWithValue("@Stretch", stretch.Stretch);
                                    command.Parameters.AddWithValue("@Score", stretch.Score);
                                    command.Parameters.AddWithValue("@Gatekeeper1", stretch.Gatekeeper1);
                                    command.Parameters.AddWithValue("@Gatekeeper2", stretch.Gatekeeper2);
                                    command.ExecuteNonQuery();
                                    Console.WriteLine("The Mutant " + Mutants_line + " of protein " + Protein_Name + " is succesfully inserted");
                                    
                                }
                            }
                        }
                            file_counter++;
                        }


                        Global_file.Close();
                    }//Tango Window file end
                }

                Mutants_file.Close();
            }//Mutation_List file end
            connection.Close();
        }
        static public void Insert_Foldx_SequenceDetail(string Protein_Name)
        {
            string Mutants_line;
            string Sequence_line;
            string Mapping_line;
            int counter = 0;
            int PDB_Start=0;
            int PDB_End=0;
            int Uniprot_Start=0;
            int Uniprot_End=0;
            int Modified_Start = 0;
            string Note_line;
            int Modified_End = 0;
            string PDB_ID = "";
            char[] delimiters = new char[] { '\t' };
            string MyConString = "SERVER=localhost;" +
           "DATABASE=aggreation_db;" +
           "UID=root;" +
           "PASSWORD=mahmoud;";
            MySqlConnection connection = new MySqlConnection(MyConString);
            connection.Open();
            MySqlCommand command = connection.CreateCommand();
            MySqlDataReader Reader;
            using (StreamReader Mutants_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/Mutants_List.txt"))
            {//Mutation_List file

                while ((Mutants_line = Mutants_file.ReadLine()) != null)
                {
                    Sequences sequence = new Sequences();
                    sequence.Orignial_AA = Mutants_line.Substring(0, 1);
                    sequence.Position = int.Parse(Mutants_line.Substring(1, Mutants_line.Length - 2));
                    sequence.Mutant = Mutants_line.Substring(Mutants_line.Length - 1);
                   
                    FoldX foldx = new FoldX();
                    string[] Protein_ID_tmp = Directory.GetFiles("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/PFAM/", "*.txt").Select(path => Path.GetFileName(path)).ToArray();
                    char[] delimiters_2 = new char[] { '_' };
                    string[] Protein_ID_tmp_parts = Protein_ID_tmp[0].Split(delimiters_2, StringSplitOptions.RemoveEmptyEntries);
                    string Protein_ID = Protein_ID_tmp_parts[1].Substring(0, Protein_ID_tmp_parts[1].Length - 4);
                    command.CommandText = "select sh.Short_Stretch_ID, sh.Start, sh.End, sh.Stretch , p.PDB_ID from aggreation_db.sequences s inner join short_stretch sh on sh.Sequence_ID=s.Sequence_ID inner join proteins p on s.Protein_ID=p.uniprot_ID  where s.Protein_ID = '" + Protein_ID + "' and s.ORAA = '" + sequence.Orignial_AA + "' and s.pos =" + sequence.Position + " and s.Mutant = '" + sequence.Mutant + "' ";
                    Reader = command.ExecuteReader();
                    while (Reader.Read())
                    {

                        Short_Stretch stretch = new Short_Stretch();
                        foldx.Short_Stretch_ID = int.Parse(Reader.GetValue(0).ToString());
                        stretch.Start = int.Parse(Reader.GetValue(1).ToString());
                        stretch.End = int.Parse(Reader.GetValue(2).ToString());
                        stretch.Stretch = Reader.GetValue(3).ToString();
                        PDB_ID = Reader.GetValue(4).ToString();

                                char[] delimiters_4 = new char[] { '_' };
                                string[] PDB_ID_ARR = PDB_ID.Split(delimiters_4, StringSplitOptions.RemoveEmptyEntries);
                                if (PDB_ID_ARR.Length > 1)
                                {
                                    string[] Mapping_line_parts;
                                    using (StreamReader Mutants_Mapping_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Mapping.txt"))
                                    {

                                        while ((Mapping_line = Mutants_Mapping_file.ReadLine()) != null)
                                        {
                                            if (Mapping_line.Contains(Mutants_line))
                                            {
                                                Mapping_line_parts = Mapping_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                                PDB_ID = Mapping_line_parts[1];
                                            }
                                        }
                                    }
                                }
                                if (Mutants_line.Equals("alpha-synuclein"))
                                {
                                    string[] Mapping_line_parts;
                                    using (StreamReader Mutants_Mapping_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/pdb_avaliable.txt"))
                                    {

                                        while ((Mapping_line = Mutants_Mapping_file.ReadLine()) != null)
                                        {

                                                Mapping_line_parts = Mapping_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                                char[] del = new char[] { '-' };
                                               string[] parts = Mapping_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                               if (stretch.Start >= int.Parse(parts[0]) && stretch.End <= int.Parse(parts[2]))
                                               {
                                                   PDB_ID = Mapping_line_parts[0];
                                               }
                                           
                                        }
                                    }
                                }


                        using (StreamReader Mapping_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/pdb_chain_uniprot.lst.txt"))
                        {//
                            while ((Mapping_line = Mapping_file.ReadLine()) != null)
                            {
                                
                                string[] Mapping_line_parts = Mapping_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                // if (Mapping_line_parts[0].Equals(PDB_ID) && Mapping_line_parts[2].Equals(Protein_ID))
                                if (string.Compare(Mapping_line_parts[0], PDB_ID, true) == 0 && string.Compare(Mapping_line_parts[2], Protein_ID, true) == 0)
                                {
                                    PDB_Start = int.Parse(Mapping_line_parts[5]);
                                    PDB_End = int.Parse(Mapping_line_parts[6]);
                                    Uniprot_Start = int.Parse(Mapping_line_parts[7]);
                                    Uniprot_End = int.Parse(Mapping_line_parts[8]);

                                    if (stretch.Start >= PDB_Start && stretch.End <= PDB_End)
                                    {
                                        Modified_Start = stretch.Start - Uniprot_Start + PDB_Start;
                                        Modified_End = stretch.End - Uniprot_Start + PDB_Start;
                                    }
                                }
                            }
                        }


                        if (File.Exists("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Note.txt"))
                        {
                            bool flag = false;
                            using (StreamReader Note_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/Note.txt"))
                            {

                                while ((Note_line = Note_file.ReadLine()) != null)
                                {

                                    string[] Note_line_parts = Note_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                    if (Note_line.Contains("Based"))
                                    {
                                        if (string.Compare(PDB_ID, Note_line_parts[1].Substring(0, 4), true) == 0)
                                        {
                                            flag = true;
                                        }

                                    }
                                    if (Note_line.Contains("Residue range") && flag)
                                    {
                                        char[] delimiters_5 = new char[] { ' ' };
                                        string[] res_line_parts = Note_line_parts[1].Split(delimiters_5, StringSplitOptions.RemoveEmptyEntries);
                                        PDB_Start = int.Parse(res_line_parts[0]);
                                        PDB_End = int.Parse(res_line_parts[2]);
                                        Uniprot_Start = PDB_Start;
                                        Uniprot_End = PDB_End;
                                        if (stretch.Start >= PDB_Start && stretch.End <= PDB_End)
                                        {
                                            Modified_Start = stretch.Start - Uniprot_Start + PDB_Start;
                                            Modified_End = stretch.End - Uniprot_Start + PDB_Start;
                                        }
                                    }
                                }
                            }

                        }

                        using (StreamReader Sequence_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/" + Protein_Name + "/PDB/SequenceDetail_" + PDB_ID + "/SequenceDetail_" + PDB_ID + ".fxout"))
                        {//Tango Window File
                            float AVG_Energy = 0;
                            float AVG_Energy_Vdw = 0;
                            float AVG_Energy_SolvH = 0;
                            float AVG_Energy_SolvP = 0;
                            float AVG_Energy_Vdwclash = 0;
                            float AVG_Sidechain_Burial = 0;
                            float AVG_Mainchain_Burial = 0;
                            counter = 0;
                            //bool flag = true;
                            while ((Sequence_line = Sequence_file.ReadLine()) != null)
                            {

                                counter++;
                                if (!Sequence_line.Equals(""))
                                {
                                    if (counter >= 10 && !Sequence_line.Contains("GAP"))
                                    {
                                        
                                        string[] Sequence_line_parts = Sequence_line.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                       
                                        if (int.Parse(Sequence_line_parts[2]) >= Modified_Start && int.Parse(Sequence_line_parts[2]) <= Modified_End)
                                        {
                                                AVG_Energy += float.Parse(Sequence_line_parts[3]);
                                                AVG_Energy_Vdw += float.Parse(Sequence_line_parts[14]);
                                                AVG_Energy_SolvH += float.Parse(Sequence_line_parts[15]);
                                                AVG_Energy_SolvP += float.Parse(Sequence_line_parts[16]);
                                                AVG_Energy_Vdwclash += float.Parse(Sequence_line_parts[17]);
                                                AVG_Sidechain_Burial += float.Parse(Sequence_line_parts[24]);
                                                AVG_Mainchain_Burial += float.Parse(Sequence_line_parts[25]);

                                        }
                                    }
                                }
                            }

                            Sequence_file.Close();

                                foldx.Energy = AVG_Energy / (stretch.End - stretch.Start + 1);
                                foldx.Energy_Vdw = AVG_Energy_Vdw / (stretch.End - stretch.Start + 1);
                                foldx.Energy_SolvH = AVG_Energy_SolvH / (stretch.End - stretch.Start + 1);
                                foldx.Energy_SolvP = AVG_Energy_SolvP / (stretch.End - stretch.Start + 1);
                                foldx.Energy_Vdwclash = AVG_Energy_Vdwclash / (stretch.End - stretch.Start + 1);
                                foldx.Sidechain_Burial = AVG_Sidechain_Burial / (stretch.End - stretch.Start + 1);
                                foldx.Mainchain_Burial = AVG_Mainchain_Burial / (stretch.End - stretch.Start + 1);

                                excute(foldx.Short_Stretch_ID, foldx.Energy, foldx.Energy_Vdw, foldx.Energy_SolvH, foldx.Energy_SolvP, foldx.Energy_Vdwclash, foldx.Sidechain_Burial, foldx.Mainchain_Burial);
                                Console.WriteLine("The mutant " + Mutants_line + " of Protein " + Protein_Name + " FOLDX sequence successuflly inserted");
                        }//Tango Window file end

                    }

                    Reader.Close();
                }

                Mutants_file.Close();
            }//Mutation_List file end
            connection.Close();
        }
        
        static public void AA_Names()
        {
            hshTable.Add("A", "ALA");
            hshTable.Add("R", "ARG");
            hshTable.Add("N", "ASN");
            hshTable.Add("D", "ASP");
            hshTable.Add("C", "CYS");
            hshTable.Add("E", "GLU");
            hshTable.Add("Q", "GLN");
            hshTable.Add("G", "GLY");
            hshTable.Add("H", "HIS");
            hshTable.Add("I", "ILE");
            hshTable.Add("L", "LEU");
            hshTable.Add("K", "LYS");
            hshTable.Add("M", "MET");
            hshTable.Add("F", "PHE");
            hshTable.Add("P", "PRO");
            hshTable.Add("S", "SER");
            hshTable.Add("T", "THR");
            hshTable.Add("W", "TRP");
            hshTable.Add("Y", "TYR");
            hshTable.Add("V", "VAL");
        }

        static void Main(string[] args)
        {
            AA_Names();

            //Insert_Proteins();

            string Protein_line;
            using (StreamReader Protein_file = new StreamReader("D:/Master of Bioinformatics/Ubuntu/Data_Set/Proteins_Names.txt"))
            {
                while ((Protein_line = Protein_file.ReadLine()) != null)
                {
                 //   Insert_Sequences(Protein_line);
                 // Insert_Stretch(Protein_line);
                  Insert_Foldx_SequenceDetail(Protein_line);
                }
                Protein_file.Close();
            }
            Console.ReadLine();

        }
    }
}




//string MyConString = "SERVER=localhost;" +
//"DATABASE=aggreation_db;" +
//"UID=root;" +
//"PASSWORD=mahmoud;";
//MySqlConnection connection = new MySqlConnection(MyConString);
//MySqlCommand command = connection.CreateCommand();
//MySqlDataReader Reader;
//command.CommandText = "select * from aggreation_db.proteins";
//connection.Open();
//Reader = command.ExecuteReader();
//while (Reader.Read())
//{
//    string thisrow = "";
//    for (int i = 0; i < Reader.FieldCount; i++)
//    {
//        thisrow = Reader.GetValue(i).ToString();
//        Console.WriteLine(thisrow);
//    }
//}
//connection.Close();
