// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.Integration.Shopify;

/// <summary>
/// Codeunit Shpfy GQL NextProductImages (ID 70007684) implements Interface Shpfy IGraphQL.
/// </summary>
codeunit 30140 "Shpfy GQL NextProductImages" implements "Shpfy IGraphQL"
{
    Access = Internal;

    /// <summary>
    /// GetGraphQL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetGraphQL(): Text
    begin
        exit('{"query":"{products(first:100, after:\"{{After}}\"){pageInfo{hasNextPage} edges{cursor node{legacyResourceId media(first:1) { edges { node { mediaContentType ... on MediaImage { id image { url(transform: {maxHeight: 360, maxWidth: 360})}}}}}}}}}"}');
    end;

    /// <summary>
    /// GetExpectedCost.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    internal procedure GetExpectedCost(): Integer
    begin
        exit(420);
    end;

}
