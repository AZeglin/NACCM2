using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VA.NAC.NACCMBrowser.BrowserObj
{
    // fields for EditContractSalesHeaderFormView to bind to
    [Serializable]
    public class EditContractSalesHeaderContent
    {
        private string _contractNumber = "";
        private int _quarter = -1;
        private int _quarterId = -1;
        private int _year = DateTime.MinValue.Year;
        private bool _bIsNewQuarter = false;
        private bool _bHasNewQuarterBeenSelected = false;


        public EditContractSalesHeaderContent()
        {

        }

        public EditContractSalesHeaderContent( EditContractSalesWindowParms editContractSalesWindowParms )
        {
            _bIsNewQuarter = editContractSalesWindowParms.IsNewQuarter;
            _contractNumber = editContractSalesWindowParms.ContractNumber;

            if( _bIsNewQuarter == false )
            {
                _quarter = editContractSalesWindowParms.Quarter;
                _quarterId = editContractSalesWindowParms.QuarterId;
                _year = editContractSalesWindowParms.Year;
            }
        }

        public string ContractNumber
        {
            get { return _contractNumber; }
            set { _contractNumber = value; }
        }

        public int Quarter
        {
            get { return _quarter; }
            set { _quarter = value; }
        }

        public int QuarterId
        {
            get { return _quarterId; }
            set { _quarterId = value; }
        }

        public int Year
        {
            get { return _year; }
            set { _year = value; }
        }

        public bool IsNewQuarter
        {
            get { return _bIsNewQuarter; }
            set { _bIsNewQuarter = value; }
        }

        public bool HasNewQuarterBeenSelected
        {
            get { return _bHasNewQuarterBeenSelected; }
            set { _bHasNewQuarterBeenSelected = value; }
        }

    }
}
