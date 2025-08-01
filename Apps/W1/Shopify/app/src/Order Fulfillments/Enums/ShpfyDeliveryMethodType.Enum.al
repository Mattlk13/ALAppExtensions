// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.Integration.Shopify;

/// <summary>
/// Enum Shpfy Delivery Method Type (ID 30152).
/// </summary>
enum 30152 "Shpfy Delivery Method Type"
{
    Caption = 'Shopify Delivery Method Type';
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Local")
    {
        Caption = 'Local';
    }
    value(2; "None")
    {
        Caption = 'None';
    }
    value(3; "Pick Up")
    {
        Caption = 'Pick Up';
    }
    value(4; "Retail")
    {
        Caption = 'Retail';
    }
    value(5; "Shipping")
    {
        Caption = 'Shipping';
    }
    value(6; "Pickup Point")
    {
        Caption = 'Pickup Point';
    }
}