using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Project
{
    class Sequences
    {
        //public Proteins protein { get; set; }
        public string Protein_ID { get; set; }
        public string Orignial_AA { get; set; }
        public int Position { get; set; }
        public string Mutant { get; set; }
        public float dTango { get; set; }
        public float dWaltz { get; set; }
        public float dAgadir { get; set; }
        public float dLimbo { get; set; }
        public float Tango { get; set; }
        public float Waltz { get; set; }
        public float Agadir { get; set; }
        public float Limbo { get; set; }
        public float ddG { get; set; }
        public float BLOSUM62 { get; set; }
        public float BLOSUM45 { get; set; }
        public float BLOSUM80 { get; set; }
        public float SIFT { get; set; }
        public string Secondary_Structure { get; set; }
        public float Consurf_Score { get; set; }
        public int Consurf_Color { get; set; }
        public string Consurf_B_E { get; set; }
        public string Consurf_Function { get; set; }
        public int Distance_To_Tango { get; set; }
        public int Gain_Loss_Tango { get; set; }
        public string Aggregate { get; set; }
        public Sequences()
        {
        }
    }
}
