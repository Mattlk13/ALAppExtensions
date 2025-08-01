// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
#pragma warning disable AA0247

permissionset 11782 "CZ Cash Desk - Objects CZP"
{
    Access = Public;
    Assignable = false;
    Caption = 'CZ Cash Desk - Objects';

    Permissions = Codeunit "Bank Account Handler CZP" = X,
                  Codeunit "Cash Desk Management CZP" = X,
                  Codeunit "Cash Desk Single Instance CZP" = X,
                  Codeunit "Cash Document Approv. Mgt. CZP" = X,
                  Codeunit "Cash Document-Post CZP" = X,
                  Codeunit "Cash Document-Post + Print CZP" = X,
                  Codeunit "Cash Document-Post(Yes/No) CZP" = X,
                  Codeunit "Cash Document-Release CZP" = X,
                  Codeunit "Cash Document-ReleasePrint CZP" = X,
                  Codeunit "Cash Document Totals CZP" = X,
                  Codeunit "Copy Cash Document Mgt. CZP" = X,
                  Codeunit "Cross Application Handler CZP" = X,
                  Codeunit "Data Class. Eval. Handler CZP" = X,
                  Codeunit "Default Dimension Handler CZP" = X,
                  Codeunit "Doc. Attachment Handler CZP" = X,
                  Codeunit "EET Cash Desk CZP" = X,
                  Codeunit "EET Management CZP" = X,
                  Codeunit "Gen. Ledger Setup Handler CZP" = X,
                  Codeunit "Guided Experience Handler CZP" = X,
                  Codeunit "Install Application CZP" = X,
                  Codeunit "Manual Cross App. Handler CZP" = X,
                  Codeunit "Navigate Handler CZP" = X,
                  Codeunit "Notification Handler CZP" = X,
                  Codeunit "Purchase Handler CZP" = X,
                  Codeunit "Sales Handler CZP" = X,
                  Codeunit "Service Handler CZP" = X,
                  Codeunit "Transfer Extended Text CZP" = X,
                  Codeunit "Upgrade Application CZP" = X,
                  Codeunit "Upgrade Tag Definitions CZP" = X,
                  Codeunit "Workflow Handler CZP" = X,
                  Codeunit "Reconciliation Handler CZP" = X,
                  Page "Cash Desk Activities CZP" = X,
                  Page "Cash Desk Card CZP" = X,
                  Page "Cash Desk Events CZP" = X,
                  Page "Cash Desk Events Setup CZP" = X,
                  Page "Cash Desk FactBox CZP" = X,
                  Page "Cash Desk List CZP" = X,
                  Page "Cash Desk Role Center CZP" = X,
                  Page "Cash Desk Statistics CZP" = X,
                  Page "Cash Desk Users CZP" = X,
                  Page "Cash Document CZP" = X,
                  Page "Cash Document Lines CZP" = X,
                  Page "Cash Document List CZP" = X,
#if not CLEAN27
                  Page "Cash Document Statistics CZP" = X,
#endif
                  Page "Cash Doc. Statistics CZP" = X,
                  Page "Cash Document Subform CZP" = X,
                  Page "Currency Nominal Values CZP" = X,
                  Page "Posted Cash Document CZP" = X,
                  Page "Posted Cash Document List CZP" = X,
#if not CLEAN27
                  Page "Posted Cash Document Stat. CZP" = X,
#endif
                  Page "Posted Cash Doc. Stat. CZP" = X,
                  Page "Posted Cash Document Subf. CZP" = X,
                  Page "Posted Cash Document Lines CZP" = X,
                  Page "Report Selection Cash Desk CZP" = X,
                  Report "Cash Desk Account Book CZP" = X,
                  Report "Cash Desk Book CZP" = X,
                  Report "Cash Desk Hand Over CZP" = X,
                  Report "Cash Desk Inventory CZP" = X,
                  Report "Copy Cash Document CZP" = X,
                  Report "Posted Rcpt. Cash Document CZP" = X,
                  Report "Posted Wdrl. Cash Document CZP" = X,
                  Report "Receipt Cash Document CZP" = X,
                  Report "Withdrawal Cash Document CZP" = X,
                  Table "Cash Desk CZP" = X,
                  Table "Cash Desk Cue CZP" = X,
                  Table "Cash Desk Event CZP" = X,
                  Table "Cash Desk Rep. Selections CZP" = X,
                  Table "Cash Desk User CZP" = X,
                  Table "Cash Document Header CZP" = X,
                  Table "Cash Document Line CZP" = X,
                  Table "Currency Nominal Value CZP" = X,
                  Table "Posted Cash Document Hdr. CZP" = X,
                  Table "Posted Cash Document Line CZP" = X;
}
