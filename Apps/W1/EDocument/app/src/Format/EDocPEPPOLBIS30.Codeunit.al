namespace Microsoft.eServices.EDocument.IO.Peppol;

using Microsoft.eServices.EDocument;
using System.Utilities;
using Microsoft.Sales.Peppol;
using Microsoft.Purchases.Document;
using Microsoft.Service.History;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.FinanceCharge;
using Microsoft.Sales.Reminder;
using Microsoft.EServices.EDocument.Format;
using Microsoft.Inventory.Transfer;

codeunit 6165 "EDoc PEPPOL BIS 3.0" implements "E-Document"
{
    procedure Check(var SourceDocumentHeader: RecordRef; EDocumentService: Record "E-Document Service"; EDocumentProcessingPhase: Enum "E-Document Processing Phase")
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ReminderHeader: Record "Reminder Header";
        FinChargeMemoHeader: Record "Finance Charge Memo Header";
        PEPPOLValidation: Codeunit "PEPPOL Validation";
        PEPPOLServiceValidation: Codeunit "PEPPOL Service Validation";
        EDocPEPPOLValidation: Codeunit "E-Doc. PEPPOL Validation";
    begin
        case SourceDocumentHeader.Number of
            Database::"Sales Header":
                begin
                    SourceDocumentHeader.SetTable(SalesHeader);
                    PEPPOLValidation.Run(SalesHeader);
                end;
            Database::"Sales Invoice Header":
                begin
                    SourceDocumentHeader.SetTable(SalesInvoiceHeader);
                    PEPPOLValidation.CheckSalesInvoice(SalesInvoiceHeader);
                end;
            Database::"Sales Cr.Memo Header":
                begin
                    SourceDocumentHeader.SetTable(SalesCrMemoHeader);
                    PEPPOLValidation.CheckSalesCreditMemo(SalesCrMemoHeader);
                end;
            Database::"Service Invoice Header":
                begin
                    SourceDocumentHeader.SetTable(ServiceInvoiceHeader);
                    PEPPOLServiceValidation.CheckServiceInvoice(ServiceInvoiceHeader);
                end;
            Database::"Service Cr.Memo Header":
                begin
                    SourceDocumentHeader.SetTable(ServiceCrMemoHeader);
                    PEPPOLServiceValidation.CheckServiceCreditMemo(ServiceCrMemoHeader);
                end;
            Database::"Reminder Header":
                begin
                    SourceDocumentHeader.SetTable(ReminderHeader);
                    EDocPEPPOLValidation.CheckReminder(ReminderHeader);
                end;
            Database::"Finance Charge Memo Header":
                begin
                    SourceDocumentHeader.SetTable(FinChargeMemoHeader);
                    EDocPEPPOLValidation.CheckFinChargeMemo(FinChargeMemoHeader);
                end;
        end;
    end;

    procedure Create(EDocumentService: Record "E-Document Service"; var EDocument: Record "E-Document"; var SourceDocumentHeader: RecordRef; var SourceDocumentLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    var
        EDocErrorHelper: Codeunit "E-Document Error Helper";
        DocOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(DocOutStream);
        case EDocument."Document Type" of
            EDocument."Document Type"::"Sales Invoice", EDocument."Document Type"::"Service Invoice":
                GenerateInvoiceXMLFile(SourceDocumentHeader, DocOutStream, EDocumentService."Embed PDF in export");
            EDocument."Document Type"::"Sales Credit Memo", EDocument."Document Type"::"Service Credit Memo":
                GenerateCrMemoXMLFile(SourceDocumentHeader, DocOutStream, EDocumentService."Embed PDF in export");
            EDocument."Document Type"::"Issued Reminder", EDocument."Document Type"::"Issued Finance Charge Memo":
                GenerateFinancialResultsXMLFile(SourceDocumentHeader, DocOutStream);
            EDocument."Document Type"::"Sales Shipment":
                GenerateShipmentXMLFile(SourceDocumentHeader, DocOutStream, EDocumentService."Embed PDF in export");
            EDocument."Document Type"::"Transfer Shipment":
                GenerateTransferShipmentXMLFile(SourceDocumentHeader, DocOutStream, EDocumentService."Embed PDF in export");
            else
                EDocErrorHelper.LogSimpleErrorMessage(EDocument, StrSubstNo(DocumentTypeNotSupportedErr, EDocument.FieldCaption("Document Type"), EDocument."Document Type"));
        end;

        // Raise event to allow customizations to modify the XML document
        OnAfterCreatePEPPOLXMLDocument(EDocumentService, EDocument, SourceDocumentHeader, SourceDocumentLines, TempBlob);
    end;

    procedure CreateBatch(EDocService: Record "E-Document Service"; var EDocument: Record "E-Document"; var SourceDocumentHeaders: RecordRef; var SourceDocumentsLines: RecordRef; var TempBlob: codeunit "Temp Blob");
    begin

    end;

    procedure GetBasicInfoFromReceivedDocument(var EDocument: Record "E-Document"; var TempBlob: Codeunit "Temp Blob")
    begin
        ImportPeppol.ParseBasicInfo(EDocument, TempBlob);
    end;

    procedure GetCompleteInfoFromReceivedDocument(var EDocument: Record "E-Document"; var CreatedDocumentHeader: RecordRef; var CreatedDocumentLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    var
        TempPurchaseHeader: Record "Purchase Header" temporary;
        TempPurchaseLine: Record "Purchase Line" temporary;
    begin
        ImportPeppol.ParseCompleteInfo(EDocument, TempPurchaseHeader, TempPurchaseLine, TempBlob);

        CreatedDocumentHeader.GetTable(TempPurchaseHeader);
        CreatedDocumentLines.GetTable(TempPurchaseLine);
    end;

    local procedure GenerateInvoiceXMLFile(VariantRec: Variant; var OutStr: OutStream; GeneratePDF: Boolean)
    var
        SalesInvoicePEPPOLBIS30: XMLport "Sales Invoice - PEPPOL BIS 3.0";
    begin
        SalesInvoicePEPPOLBIS30.Initialize(VariantRec);
        SalesInvoicePEPPOLBIS30.SetGeneratePDF(GeneratePDF);
        SalesInvoicePEPPOLBIS30.SetDestination(OutStr);
        SalesInvoicePEPPOLBIS30.Export();
    end;

    local procedure GenerateCrMemoXMLFile(VariantRec: Variant; var OutStr: OutStream; GeneratePDF: Boolean)
    var
        SalesCrMemoPEPPOLBIS30: XMLport "Sales Cr.Memo - PEPPOL BIS 3.0";
    begin
        SalesCrMemoPEPPOLBIS30.Initialize(VariantRec);
        SalesCrMemoPEPPOLBIS30.SetGeneratePDF(GeneratePDF);
        SalesCrMemoPEPPOLBIS30.SetDestination(OutStr);
        SalesCrMemoPEPPOLBIS30.Export();
    end;

    local procedure GenerateFinancialResultsXMLFile(VariantRec: Variant; var OutStr: OutStream)
    var
        FinResultsPEPPOLBIS30: XMLport "Fin. Results - PEPPOL BIS 3.0";
    begin
        FinResultsPEPPOLBIS30.Initialize(VariantRec);
        FinResultsPEPPOLBIS30.SetDestination(OutStr);
        FinResultsPEPPOLBIS30.Export();
    end;

    local procedure GenerateShipmentXMLFile(ShipmentRecRef: RecordRef; var OutStr: OutStream; GeneratePDF: Boolean)
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentExport: Codeunit "E-Doc. Shipment Export To XML";
        TempBlob: Codeunit "Temp Blob";
    begin
        ShipmentRecRef.SetTable(SalesShipmentHeader);
        SalesShipmentExport.SetGeneratePDF(GeneratePDF);
        SalesShipmentExport.Run(SalesShipmentHeader);
        SalesShipmentExport.GetShipmentXml(TempBlob);
        CopyStream(OutStr, TempBlob.CreateInStream());
    end;

    local procedure GenerateTransferShipmentXMLFile(var TransferShipmentHeaderRecRef: RecordRef; DocOutStream: OutStream; GeneratePDF: Boolean)
    var
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentExport: Codeunit "E-Doc. Transfer Shpt. To XML";
        TempBlob: Codeunit "Temp Blob";
    begin
        TransferShipmentHeader := TransferShipmentHeaderRecRef;
        TransferShipmentExport.SetGeneratePDF(GeneratePDF);
        TransferShipmentExport.Run(TransferShipmentHeader);
        TransferShipmentExport.GetTransferShipmentXML(TempBlob);
        CopyStream(DocOutStream, TempBlob.CreateInStream());
    end;

    [EventSubscriber(ObjectType::Table, Database::"E-Document Service", 'OnAfterValidateEvent', 'Document Format', false, false)]
    local procedure OnAfterValidateDocumentFormat(var Rec: Record "E-Document Service"; var xRec: Record "E-Document Service"; CurrFieldNo: Integer)
    var
        EDocServiceSupportedType: Record "E-Doc. Service Supported Type";
    begin
        if Rec."Document Format" = Rec."Document Format"::"PEPPOL BIS 3.0" then begin
            EDocServiceSupportedType.SetRange("E-Document Service Code", Rec.Code);
            if EDocServiceSupportedType.IsEmpty() then begin
                EDocServiceSupportedType.Init();
                EDocServiceSupportedType."E-Document Service Code" := Rec.Code;
                EDocServiceSupportedType."Source Document Type" := EDocServiceSupportedType."Source Document Type"::"Sales Invoice";
                EDocServiceSupportedType.Insert();

                EDocServiceSupportedType."Source Document Type" := EDocServiceSupportedType."Source Document Type"::"Sales Credit Memo";
                EDocServiceSupportedType.Insert();

                EDocServiceSupportedType."Source Document Type" := EDocServiceSupportedType."Source Document Type"::"Service Invoice";
                EDocServiceSupportedType.Insert();

                EDocServiceSupportedType."Source Document Type" := EDocServiceSupportedType."Source Document Type"::"Service Credit Memo";
                EDocServiceSupportedType.Insert();
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePEPPOLXMLDocument(EDocumentService: Record "E-Document Service"; var EDocument: Record "E-Document"; var SourceDocumentHeader: RecordRef; var SourceDocumentLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    begin
    end;

    var
        ImportPeppol: Codeunit "EDoc Import PEPPOL BIS 3.0";
        DocumentTypeNotSupportedErr: Label '%1 %2 is not supported by PEPPOL BIS30 Format', Comment = '%1 - Document Type caption, %2 - Document Type';
}