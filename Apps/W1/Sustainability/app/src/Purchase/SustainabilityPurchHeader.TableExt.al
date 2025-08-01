namespace Microsoft.Sustainability.Purchase;

using Microsoft.Sustainability.Setup;
using Microsoft.Purchases.Document;

tableextension 6212 "Sustainability Purch. Header" extends "Purchase Header"
{
    fields
    {
        field(6210; "Sustainability Lines Exist"; Boolean)
        {
            Caption = 'Sustainability Lines Exist';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Sust. Account No." = filter('<>'''''), "Document No." = field("No.")));
        }
        field(6211; "Emission C02"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Emission CO2" where("Document Type" = field("Document Type"),
                                                            "Document No." = field("No.")));
            Caption = 'Emission CO2';
            CaptionClass = '102,6,1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6212; "Emission CH4"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Emission CH4" where("Document Type" = field("Document Type"),
                                                            "Document No." = field("No.")));
            Caption = 'Emission CH4';
            CaptionClass = '102,6,2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6213; "Emission N2O"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Emission N2O" where("Document Type" = field("Document Type"),
                                                            "Document No." = field("No.")));
            Caption = 'Emission N2O';
            CaptionClass = '102,6,3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6214; "Posted Emission C02"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Posted Emission CO2" where("Document Type" = field("Document Type"),
                                                            "Document No." = field("No.")));
            Caption = 'Posted Emission CO2';
            CaptionClass = '102,11,1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6215; "Posted Emission CH4"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Posted Emission CH4" where("Document Type" = field("Document Type"),
                                                            "Document No." = field("No.")));
            Caption = 'Posted Emission CH4';
            CaptionClass = '102,11,2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6216; "Posted Emission N2O"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Posted Emission N2O" where("Document Type" = field("Document Type"),
                                                            "Document No." = field("No.")));
            Caption = 'Posted Emission N2O';
            CaptionClass = '102,11,3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6217; "Energy Consumption"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Energy Consumption" where("Document Type" = field("Document Type"),
                                                                         "Document No." = field("No.")));
            Caption = 'Energy Consumption';
            CaptionClass = '102,13,4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6218; "Posted Energy Consumption"; Decimal)
        {
            AutoFormatType = 11;
            AutoFormatExpression = SustainabilitySetup.GetFormat(SustainabilitySetup.FieldNo("Emission Decimal Places"));
            CalcFormula = sum("Purchase Line"."Posted Energy Consumption" where("Document Type" = field("Document Type"),
                                                                                "Document No." = field("No.")));
            Caption = 'Posted Energy Consumption';
            CaptionClass = '102,14,4';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        SustainabilitySetup: Record "Sustainability Setup";
}