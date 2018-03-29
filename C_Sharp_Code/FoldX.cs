using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Project
{
    class FoldX
    {
        public int Short_Stretch_ID { get; set; }
        public float Energy { get; set; }
        public float Energy_Vdw { get; set; }
        public float Energy_SolvH { get; set; }
        public float Energy_SolvP { get; set; }
        public float Energy_Vdwclash { get; set; }
        public float Sidechain_Burial { get; set; }
        public float Mainchain_Burial { get; set; }

        public FoldX()
        {

        }
    }
}
