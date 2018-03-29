using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Project
{
    class Domain
    {
        public string Protein_ID { get; set; }
        public string Source { get; set; }
        public int Start { get; set; }
        public int End { get; set; }
        public string Domain_Name { get; set; }
        public Domain()
        {

        }
    }
}
