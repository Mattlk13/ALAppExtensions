// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.Integration.Shopify;

using Microsoft.Sales.History;

/// <summary>
/// TableExtension Shpfy Sales Invoice Header (ID 30102) extends Record Sales Invoice Header.
/// </summary>
tableextension 30102 "Shpfy Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(30100; "Shpfy Order Id"; BigInteger)
        {
            Caption = 'Shopify Order Id';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(30101; "Shpfy Order No."; Code[50])
        {
            Caption = 'Shopify Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}

