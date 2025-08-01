// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.Integration.Shopify;

/// <summary>
/// Codeunit Shpfy GQL InventoryEntries (ID 30133) implements Interface Shpfy IGraphQL.
/// </summary>
codeunit 30133 "Shpfy GQL InventoryEntries" implements "Shpfy IGraphQL"
{
    Access = Internal;

    /// <summary>
    /// GetGraphQL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetGraphQL(): Text
    begin
        exit('{"query":"{location(id:\"gid://shopify/Location/{{LocationId}}\"){inventoryLevels(first:100){pageInfo{hasNextPage} edges{cursor node{id quantities(names: \"available\") {quantity} item{id variant{id product{id}}}}}}}}"}');
    end;

    /// <summary>
    /// GetExpectedCost.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    internal procedure GetExpectedCost(): Integer
    begin
        exit(403);
    end;

}
