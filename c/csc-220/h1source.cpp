/* ////////////////////////////////////////////////////////////////////////
   NAME: Dindo Liboon
   DATE: June 09th, 2001
PROJECT: Homework #1, CSC-220-01
PURPOSE: Reads a set of records from a binary file and displays the
         information in a brief mannor. Choosing a record will display
         detailed information about the pay and tax calculations.
  NOTES: This is the original program. I do plan on changing it or doing
         a rewrite to make it more simple.
COMPILE: CXX h1.cpp
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */

#include <iostream>
#include <fstream>
#include <iomanip>

/* #define OS_DOS */				// it's a DOS program
#define OS_UNIX					// it's a UNIX program

#ifdef OS_DOS
    using namespace std;			// use std. namespace
#endif

typedef struct PAYROLL_T			// payroll structure
{						// equal to 40 bytes
    char  szName[22];
    int   iHours;
    int   iOvertime;
    int   iSundays;
    float rWage;
} PAYROLL;

const float cnrMEDICAL = 0.0135f;		// deduction constants
const float cnrFEDERAL = 0.0350f;
const float cnrSTATE   = 0.0328f;
const float cnrFEGL    = 0.0044f;
const float cnrSOCIAL  = 0.0620f;
const float cnrHEALTH  = 48.00f;

void  Cls();					// function prototypes
void  NewLine();
void  ShowLine();
void  WaitForKey();
int   EnterChoice();
void  ShowDetails(PAYROLL);
void  AddAccount(fstream &);
void  ListAccount(fstream &);
float CalculateTaxes(float);
float CalculatePay(PAYROLL);
void  RemoveAccount(fstream &);
void  UpdateAccount(fstream &);

// create a list of options
enum Choices {ADD = 1, REMOVE, UPDATE, LIST, QUIT};

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Main application code that checks if the data file is available
         for editing and handles the menu selection.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int main()
{
    fstream fpRecord;
    int iChoice;

    // check if file can be accessed
    fpRecord.open("records.dat", ios::in | ios::out);
    if (!fpRecord)
    {
        cerr << "Unable to access records.dat.";
        #ifdef OS_UNIX
            return 0;
        #else
            exit(EXIT_FAILURE);
        #endif
    }

    for(;;)					// handles menus
    {
        iChoice = EnterChoice();

        switch (iChoice)
        {
        case ADD:
            AddAccount(fpRecord);
            break;
        case REMOVE:
            RemoveAccount(fpRecord);
            break;
        case UPDATE:
            UpdateAccount(fpRecord);
            break;
        case QUIT:
            fpRecord.close();			// close data file
            #ifdef OS_UNIX
                return 0;
            #else
                exit(EXIT_SUCCESS);
            #endif
            break;
        case LIST:
           ListAccount(fpRecord);
           break;
        default:
           cout << "Invalid choice.\n";
           break;
        }

        #ifdef OS_DOS
            WaitForKey();
        #endif
    }

    return 0;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Displays a menu of available options.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
int EnterChoice()
{
    int iChoice;

    Cls();
    ShowLine();
    cout << setw(42) << "MAIN MENU" << endl;
    ShowLine();
    cout << "1 -> Add a new account\n"
         << "2 -> Remove an existing account\n"
         << "3 -> Update an existing account\n"
         << "4 -> List account information\n"
         << "5 -> Quit program\n";
    ShowLine();
    cout << "What would you like to do today? ";
    cin >> iChoice;

    return iChoice;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: address of fstream
 OUTPUT: none
PURPOSE: Adds a new account to the data file.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void AddAccount(fstream &fp)
{
    PAYROLL rcd;
    long    lFileSize;
    long    lRecordCnt;

    // get file size
    fp.seekg(0, ifstream::end);
    lFileSize = fp.tellg();

    // count number of records that exist
    lRecordCnt = lFileSize / sizeof(PAYROLL);

    // read record information from keyboard
    cout << "Name (lastname, firstname): ";
    gets(rcd.szName);

    cout << "Hours Worked (1 - 160): ";
    cin >> rcd.iHours;

    cout << "Overtime Hours (1+): ";
    cin >> rcd.iOvertime;

    cout << "Sunday Hours (1 - 32): ";
    cin >> rcd.iSundays;

    cout << "Hourly Rate (1.00+): ";
    cin >> rcd.rWage;

    fp.seekp(lRecordCnt * sizeof(PAYROLL));
    fp.write((char*)&rcd, sizeof(PAYROLL));
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: address of fstream
 OUTPUT: none
PURPOSE: Clears out an existing account in the data file.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void RemoveAccount(fstream &fp)
{
    PAYROLL rcd = {"", 0, 0, 0, 0.0};
    long    lFileSize;
    long    lRecordCnt;
    int     iRmvRecord;

    // get file size
    fp.seekg(0, ifstream::end);
    lFileSize = fp.tellg();

    // count number of records that exist
    lRecordCnt = lFileSize / sizeof(PAYROLL);

    cout << "Which account number would you like to remove? ";
    cin >> iRmvRecord;

    if (iRmvRecord >= 1 && iRmvRecord <= lRecordCnt)
    {
        fp.seekp((iRmvRecord - 1) * sizeof(PAYROLL));
        fp.write((char*)&rcd, sizeof(PAYROLL));
    }
    else
        cout << "Error, account number does not exist\n";
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: address of fstream
 OUTPUT: none
PURPOSE: Updates an existing account in the data file.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void UpdateAccount(fstream &fp)
{
    PAYROLL rcd;
    long    lFileSize;
    long    lRecordCnt;
    int     iUpdRecord;

    // get file size
    fp.seekg(0, ifstream::end);
    lFileSize = fp.tellg();

    // count number of records that exist
    lRecordCnt = lFileSize / sizeof(PAYROLL);

    cout << "Which account number would you like to update? ";
    cin >> iUpdRecord;

    if (iUpdRecord >= 1 && iUpdRecord <= lRecordCnt)
    {
        // read record information from keyboard
        cout << "Name (lastname, firstname): ";
        gets(rcd.szName);

        cout << "Hours Worked (1 - 160): ";
        cin >> rcd.iHours;

        cout << "Overtime Hours (1+): ";
        cin >> rcd.iOvertime;

        cout << "Sunday Hours (1 - 32): ";
        cin >> rcd.iSundays;

        cout << "Hourly Rate (1.00+): ";
        cin >> rcd.rWage;

        fp.seekp((iUpdRecord - 1) * sizeof(PAYROLL));
        fp.write((char*)&rcd, sizeof(PAYROLL));
    }
    else
        cout << "Error, account number does not exist\n";
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Draws a line of 75 characters.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void ShowLine()
{
    for (int iTmp = 1; iTmp <= 75; iTmp++)
        cout << "=";
    NewLine();
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Moves cursor to the next line on the screen.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void NewLine()
{
    cout << "\n";
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Waits until the user pressed the ENTER key.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void WaitForKey()
{
    char cPressKey;

    cout << "Press ENTER to continue.\n";
    do
    {
        cPressKey = getchar();
    }
    while (cPressKey != '\n');
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: address of fstream
 OUTPUT: none
PURPOSE: Gets account number to view and calls ShowDetails().
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void ListAccount(fstream &fp)
{
    PAYROLL rcd;
    long    lFileSize;
    long    lRecordCnt;
    int     iVwRecord;

    // get file size
    fp.seekg(0, ifstream::end);
    lFileSize = fp.tellg();

    // count number of records that exist
    lRecordCnt = lFileSize / sizeof(PAYROLL);

    cout << "Which account number would you like to view? ";
    cin >> iVwRecord;

    if (iVwRecord >= 1 && iVwRecord <= lRecordCnt)
    {
        fp.seekg((iVwRecord - 1) * sizeof(PAYROLL));
        fp.read((char*)&rcd, sizeof(PAYROLL));

        ShowDetails(rcd);
    }
    else
        cout << "Error, account number does not exist\n";
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: payroll record
 OUTPUT: none
PURPOSE: Prints account information to the screen.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void ShowDetails(PAYROLL rcd)
{ 
    float rPayGross;
    float rNetPay;
    float rTaxes;

    Cls();
    ShowLine();

    cout << setiosflags(ios::left | ios::fixed)
         << setiosflags(ios::showpoint)
         << setprecision(2)
         << "NAME: "
         << setw(51)  << rcd.szName
         << "HOURLY RATE: "
         << rcd.rWage << endl;

    ShowLine();

    rPayGross = CalculatePay(rcd);
    rTaxes    = CalculateTaxes(rPayGross);
    rNetPay   = rPayGross - rTaxes;

    cout << setiosflags(ios::left | ios::fixed)
         << setiosflags(ios::showpoint)
         << setprecision(2)
         << ":: DETAIL OF EARNINGS\n"
         << "   Regular    -> " << setw(3) << rcd.iHours     << " x "
         << rcd.rWage << " = $" << rcd.iHours * rcd.rWage    << "\n"
         << "   Overtime   -> " << setw(3) << rcd.iOvertime  << " x "
         << (rcd.rWage / 2.00 + rcd.rWage) << " = $"
         << (rcd.iOvertime) * (rcd.rWage / 2.00 + rcd.rWage) << "\n"
         << "   Sundays    -> " << setw(3) << rcd.iSundays   << " x "
         << rcd.rWage * 2.00    << " = $"
         << rcd.iSundays * (rcd.rWage * 2.00)                << "\n"
         << "   Gross Pay  -> ----------- = $" << rPayGross  << "\n"
         << "   Deductions -> ----------- = $" << rTaxes     << "\n"
         << "   Net Pay    -> ----------- = $" << rNetPay    << "\n\n";

    cout << setiosflags(ios::left | ios::fixed)
         << setiosflags(ios::showpoint)
         << setprecision(2)
         << ":: DETAIL OF DEDUCTIONS\n"
         << "   Medical -> 1.35% = $" << rPayGross * cnrMEDICAL << "\n"
         << "   Federal -> 3.50% = $" << rPayGross * cnrFEDERAL << "\n"
         << "   State   -> 3.28% = $" << rPayGross * cnrSTATE   << "\n"
         << "   FEGL    -> 0.44% = $" << rPayGross * cnrFEGL    << "\n"
         << "   Social  -> 6.20% = $" << rPayGross * cnrSOCIAL  << "\n"
         << "   Health  -> ----- = $48.00\n"
         << "   Total   -> ----- = $" << rTaxes << "\n";

    ShowLine();
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: gross pay
 OUTPUT: total amount of deductions
PURPOSE: Returns total amount of deductons based on gross pay.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
float CalculateTaxes(float rGrossPay)
{
    return (cnrMEDICAL * rGrossPay) + (cnrFEDERAL * rGrossPay) +
           (cnrSTATE * rGrossPay)   + (cnrFEGL * rGrossPay) +
           (cnrSOCIAL * rGrossPay)  + 48.00;
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: payroll record
 OUTPUT: gross pay
PURPOSE: Returns gross pay based on payroll record information.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
float CalculatePay(PAYROLL rcd)
{
    return (rcd.rWage * rcd.iHours) +
           ((rcd.rWage / 2.00 + rcd.rWage) * rcd.iOvertime) +
           ((rcd.rWage * 2.00) * rcd.iSundays);
}

/* ////////////////////////////////////////////////////////////////////////
  INPUT: none
 OUTPUT: none
PURPOSE: Clears console screen window.
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
void Cls()
{
    #ifdef OS_DOS
        system("clear");
    #endif
}

/* ////////////////////////////////////////////////////////////////////////
                               END OF PROGRAM
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
