// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.Integration.Shopify;

/// <summary>
/// Enum Shpfy Tax Type (ID 30110).
/// </summary>
enum 30110 "Shpfy Tax Type"
{
    Access = Internal;
    Caption = 'Shopify Tax Type';
    Extensible = true;

    value(0; None)
    {
        Caption = 'None';
    }
    value(1; Normal)
    {
        Caption = 'Normal';
    }
    value(2; Harmonized)
    {
        Caption = 'Harmonized';
    }

}
