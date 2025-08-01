namespace Microsoft.Bank.Reconciliation;

using Microsoft.Bank.Ledger;
using System.AI;
using System.Azure.KeyVault;
using System.Environment;
using System.Telemetry;
using System.Upgrade;

codeunit 7250 "Bank Rec. AI Matching Impl."
{
    Access = Internal;
    InherentPermissions = X;
    InherentEntitlements = X;

    procedure BuildBankRecCompletionTask(IncludeFewShotExample: Boolean): SecretText
    var
        CompletionTaskTxt: SecretText;
        CompletionTaskPartTxt: SecretText;
        CompletionTaskBuildingFromKeyVaultFailed: Boolean;
        ConcatSubstrTok: Label '%1%2', Locked = true;
    begin
        if GetAzureKeyVaultSecret(CompletionTaskPartTxt, 'BankAccRecAIMatching1') then
            CompletionTaskTxt := CompletionTaskPartTxt
        else
            CompletionTaskBuildingFromKeyVaultFailed := true;

        if GetAzureKeyVaultSecret(CompletionTaskPartTxt, 'BankAccRecAIMatching2') then
            CompletionTaskTxt := SecretStrSubstNo(ConcatSubstrTok, CompletionTaskTxt, CompletionTaskPartTxt)
        else
            CompletionTaskBuildingFromKeyVaultFailed := true;

        if GetAzureKeyVaultSecret(CompletionTaskPartTxt, 'BankAccRecAIMatching3') then
            CompletionTaskTxt := SecretStrSubstNo(ConcatSubstrTok, CompletionTaskTxt, CompletionTaskPartTxt)
        else
            CompletionTaskBuildingFromKeyVaultFailed := true;

        if GetAzureKeyVaultSecret(CompletionTaskPartTxt, 'BankAccRecAIMatching4') then
            CompletionTaskTxt := SecretStrSubstNo(ConcatSubstrTok, CompletionTaskTxt, CompletionTaskPartTxt)
        else
            CompletionTaskBuildingFromKeyVaultFailed := true;

        if GetAzureKeyVaultSecret(CompletionTaskPartTxt, 'BankAccRecAIMatching5') then
            CompletionTaskTxt := SecretStrSubstNo(ConcatSubstrTok, CompletionTaskTxt, CompletionTaskPartTxt)
        else
            CompletionTaskBuildingFromKeyVaultFailed := true;

        if GetAzureKeyVaultSecret(CompletionTaskPartTxt, 'BankAccRecAIMatching6') then
            CompletionTaskTxt := SecretStrSubstNo(ConcatSubstrTok, CompletionTaskTxt, CompletionTaskPartTxt)
        else
            CompletionTaskBuildingFromKeyVaultFailed := true;

        if CompletionTaskBuildingFromKeyVaultFailed then begin
            Session.LogMessage('0000LFJ', TelemetryConstructingPromptFailedErr, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::All, 'Category', FeatureName());
            Error(ConstructingPromptFailedErr);
        end;

        if (IncludeFewShotExample) then begin
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, '\n**Example 1**:\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 1, Description: A, Amount: 100, Date: 2023-07-01\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 11, DocumentNo: 111, Description: A, Amount: 100, Date: 2023-07-01\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Matches: (1, [11])\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, '\n**Example 2**:\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 2, Description: B, Amount: 200, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 22, DocumentNo: 222, Description: B, Amount: 100, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 23, DocumentNo: 223, Description: B, Amount: 100, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Matches: (2, [22, 23])\n\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, '\n**Example 3**:\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 3, Description: C, Amount: 237, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 32, DocumentNo: 322, Description: D, Amount: 205, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 33, DocumentNo: 323, Description: E, Amount: 237, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Matches: (3, [33])\n\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, '\n**Example 4**:\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 4, Description: F, Amount: 248, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 42, DocumentNo: 422, Description: G, Amount: 248, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 43, DocumentNo: 423, Description: H, Amount: 248, Date: 2023-07-03\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, '\n**Example 5**:\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 5, Description: I 522, Amount: 248, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 6, Description: I 522, Amount: 100, Date: 2023-07-05\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 52, DocumentNo: 522, Description: J, Amount: 348, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Matches: (5, [52]), (6, [52])\n\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, '\n**Example 6**:\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 7, Description: ABCD 3, Amount: 250, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Statement Line: Id: 8, Description: ABCD, Amount: 248, Date: 2023-07-05\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 62, DocumentNo: 622, Description: ABCD 3, Amount: 248, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Ledger Entry: Id: 63, DocumentNo: 623, Description: ABCD Amount: 248, Date: 2023-07-02\n');
            CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, 'Matches: (7, [62]), (8, [63])\n\n');
        end;
        CompletionTaskTxt := AddCompletionPromptLine(CompletionTaskTxt, '\n\n');
        exit(CompletionTaskTxt);
    end;

    local procedure AddCompletionPromptLine(Completion: SecretText; NewPromptLine: Text): SecretText
    var
        ConcatSubstrTok: Label '%1%2', Locked = true;
    begin
        exit(SecretStrSubstNo(ConcatSubstrTok, Completion, NewPromptLine));
    end;

    procedure BuildBankRecCompletionPrompt(TaskPrompt: SecretText; StatementLines: Text; LedgerLines: Text): SecretText
    var
        CompletionPrompt: SecretText;
        ConcatSubstrTok: Label '%1%2', Locked = true;
    begin
        LedgerLines += '"""\n**Matches**:'; // close the ledger lines section
        StatementLines += '"""\n'; // close the statement lines section
        CompletionPrompt := SecretStrSubstNo(ConcatSubstrTok, TaskPrompt, StatementLines);
        CompletionPrompt := SecretStrSubstNo(ConcatSubstrTok, CompletionPrompt, LedgerLines);
        exit(CompletionPrompt);
    end;

    procedure BuildBankRecCompletionPromptUserMessage(StatementLines: Text; LedgerLines: Text): SecretText
    var
        UserMessageTxt: SecretText;
        EmptyText: SecretText;
        ConcatSubstrTok: Label '%1%2', Locked = true;
    begin
        LedgerLines += '"""\n**Matches**:'; // close the ledger lines section
        StatementLines += '"""\n'; // close the statement lines section
        UserMessageTxt := SecretStrSubstNo(ConcatSubstrTok, EmptyText, StatementLines);
        UserMessageTxt := SecretStrSubstNo(ConcatSubstrTok, UserMessageTxt, LedgerLines);
        exit(UserMessageTxt);
    end;

    procedure BuildBankRecLedgerEntries(var LedgerLines: Text; var TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; var CandidateLedgerEntryNos: List of [Integer]): Text
    begin
        if (LedgerLines = '') then
            LedgerLines := '**Ledger Entries**:\n"""\n';

        repeat
            if not CandidateLedgerEntryNos.Contains(TempBankAccLedgerEntryMatchingBuffer."Entry No.") then
                if not HasReservedWords(TempBankAccLedgerEntryMatchingBuffer.Description) then begin
                    LedgerLines += '#Id: ' + Format(TempBankAccLedgerEntryMatchingBuffer."Entry No.");
                    if TempBankAccLedgerEntryMatchingBuffer."Document No." <> '' then
                        LedgerLines += ', DocumentNo: ' + TempBankAccLedgerEntryMatchingBuffer."Document No.";
                    LedgerLines += ', Description: ' + TempBankAccLedgerEntryMatchingBuffer.Description;
                    if TempBankAccLedgerEntryMatchingBuffer."Payment Reference" <> '' then
                        LedgerLines += ', PaymentReference: ' + TempBankAccLedgerEntryMatchingBuffer."Payment Reference";
                    if TempBankAccLedgerEntryMatchingBuffer."External Document No." <> '' then
                        LedgerLines += ', ExtDocNo: ' + TempBankAccLedgerEntryMatchingBuffer."External Document No.";
                    LedgerLines += ', Amount: ' + Format(TempBankAccLedgerEntryMatchingBuffer."Remaining Amount", 0, 9);
                    LedgerLines += ', Date: ' + Format(TempBankAccLedgerEntryMatchingBuffer."Posting Date", 0, 9);
                    LedgerLines += '\n';
                    CandidateLedgerEntryNos.Add(TempBankAccLedgerEntryMatchingBuffer."Entry No.");
                end else
                    InputWithReservedWordsFound := true;
        until (TempBankAccLedgerEntryMatchingBuffer.Next() = 0);
    end;

    local procedure FindDateFilterOnLedgerEntryBuffer(LedgerLines: Text; var TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; CandidateLedgerEntryNos: List of [Integer]; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var FromDate: Date; var ToDate: Date): Boolean
    var
        LocaLedgerEntryLines: Text;
        LocalCandidateEntryNos: List of [Integer];
        NumberOfDaysBack: array[6] of Text;
        I, Candidate : integer;
        TelemetryDimensions: Dictionary of [Text, Text];
    begin
        // we must set a date filer to reduce the ledger entry candidate list until it gets under the threshold size
        NumberOfDaysBack[1] := '';
        NumberOfDaysBack[2] := '<-30D>';
        NumberOfDaysBack[3] := '<-15D>';
        NumberOfDaysBack[4] := '<-7D>';
        NumberOfDaysBack[5] := '<-3D>';
        NumberOfDaysBack[6] := '<-1D>';
        ToDate := BankAccReconciliationLine."Transaction Date";
        if ToDate = 0D then
            ToDate := Today();

        for I := 1 to 6 do begin
            LocaLedgerEntryLines := LedgerLines;
            Clear(LocalCandidateEntryNos);
            foreach Candidate in CandidateLedgerEntryNos do
                LocalCandidateEntryNos.Add(Candidate);

            TempBankAccLedgerEntryMatchingBuffer.Reset();
            if NumberOfDaysBack[I] <> '' then begin
                FromDate := CalcDate(NumberOfDaysBack[I], ToDate);
                TempBankAccLedgerEntryMatchingBuffer.SetRange("Posting Date", FromDate, ToDate);
            end;

            if not TempBankAccLedgerEntryMatchingBuffer.FindSet() then
                exit(true);

            BuildBankRecLedgerEntries(LocaLedgerEntryLines, TempBankAccLedgerEntryMatchingBuffer, LocalCandidateEntryNos);

            // if ledger entry part of the prompt is small enough, we are done
            // we have set a good enough date filter, and FromDate and ToDate are passed back as reference
            if AOAIToken.GetGPT4TokenCount(LocaLedgerEntryLines) < LedgerEntryInputThreshold() then begin
                Session.LogMessage('0000OEL', SuccessfullyFilteredBLEListTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, 'Category', FeatureName(), 'DateFormula', NumberOfDaysBack[I]);
                exit(true);
            end;
        end;

        TelemetryDimensions.Add('Category', FeatureName());
        TelemetryDimensions.Add('DateFormula', NumberOfDaysBack[I]);
        TelemetryDimensions.Add('ToDate', Format(ToDate, 0, 9));
        TelemetryDimensions.Add('TokenSizeLedgerEntryList', Format(AOAIToken.GetGPT4TokenCount(LocaLedgerEntryLines)));
        Session.LogMessage('0000OEM', UnableToFilterBLEListUnderTokenLimitTxt, Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::All, TelemetryDimensions);
        exit(false)
    end;

    procedure BuildBankRecStatementLines(var StatementLines: Text; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"): Text
    begin
        if (StatementLines = '') then
            StatementLines := '**Statement Lines**:\n"""\n';

        repeat
            if not HasReservedWords(BankAccReconciliationLine.Description) then begin
                StatementLines += '#Id: ' + Format(BankAccReconciliationLine."Statement Line No.");
                if BankAccReconciliationLine."Document No." <> '' then
                    StatementLines += ', DocumentNo: ' + BankAccReconciliationLine."Document No.";
                StatementLines += ', Description: ' + BankAccReconciliationLine.Description;
                if BankAccReconciliationLine."Additional Transaction Info" <> '' then
                    StatementLines += ' ' + BankAccReconciliationLine."Additional Transaction Info";
                if BankAccReconciliationLine."Payment Reference No." <> '' then
                    StatementLines += ', PaymentReference: ' + BankAccReconciliationLine."Payment Reference No.";
                StatementLines += ', Amount: ' + Format(BankAccReconciliationLine.Difference, 0, 9);
                StatementLines += ', Date: ' + Format(BankAccReconciliationLine."Transaction Date", 0, 9);
                StatementLines += '\n';
            end else
                InputWithReservedWordsFound := true;
        until (BankAccReconciliationLine.Next() = 0);
    end;

    procedure RemoveShortWords(Text: Text[250]): Text[250];
    var
        Words: List of [Text];
        Word: Text[250];
        Result: Text[250];
    begin
        Words := Text.Split(' '); // split the text by spaces into a list of words
        foreach Word in Words do // loop through each word in the list
            if StrLen(Word) >= 3 then // check if the word length is at least 3
                Result += Word + ' '; // append the word and a space to the result
        Result := CopyStr(Result.TrimEnd(), 1, MaxStrLen(Result)); // remove the trailing space from the result
        Text := Result; // assign the result back to the text parameter
        exit(Text);
    end;

    procedure ComputeStringNearness(String1: Text[250]; String2: Text[250]): Decimal
    var
        RecordMatchMng: Codeunit "Record Match Mgt.";
        Score: Decimal;
    begin
        String1 := RemoveShortWords(String1);
        String2 := RemoveShortWords(String2);
        Score := RecordMatchMng.CalculateStringNearness(String1, String2, 1, 100) / 100.0;
        exit(Score);
    end;

    procedure PromptSizeThreshold(): Integer
    begin
        // this is because we are using GPT4 which has a 100K token limit
        // on top of that, we are setting aside a number of tokens for the response in MaxTokens())
        exit(18000);
    end;

    procedure LedgerEntryInputThreshold(): Integer
    begin
        // this is the max size of the part of the prompt that carries information about ledger entries
        exit(10000);
    end;

    procedure MaxTokens(): Integer
    begin
        // this is specifying how many tokens of the AI Model token limit are set aside (reserved) for the response
        exit(4096);
    end;

    internal procedure GetAzureKeyVaultSecret(var SecretValue: SecretText; SecretName: Text): Boolean;
    var
        AzureKeyVault: Codeunit "Azure Key Vault";
    begin
        if not AzureKeyVault.GetAzureKeyVaultSecret(SecretName, SecretValue) then
            exit(false);

        if SecretValue.IsEmpty() then
            exit(false);

        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Match Bank Rec. Lines", 'OnFindBestMatches', '', false, false)]
    local procedure HandleOnFindBestMatches(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; DaysTolerance: Integer; var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; var RemovedPreviouslyAssigned: Boolean; var Handled: Boolean)
    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        TempBankAccRecAIProposal: Record "Bank Acc. Rec. AI Proposal" temporary;
        BankAccRecProposal: Page "Bank Acc. Rec. AI Proposal";
    begin
        if not GuiAllowed() then
            exit;

        if not BankAccReconciliationLine.FindSet() then
            exit;

        TempBankAccRecAIProposal."Bank Account No." := BankAccReconciliationLine."Bank Account No.";
        TempBankAccRecAIProposal."Statement No." := BankAccReconciliationLine."Statement No.";
        TempBankAccRecAIProposal."Statement Type" := BankAccReconciliationLine."Statement Type";
        TempBankAccRecAIProposal.Insert();
        if TempBankAccRecAIProposal.Count() > 0 then begin
            Commit();
            BankAccRecProposal.SetRecord(TempBankAccRecAIProposal);
            BankAccRecProposal.SetStatementNo(BankAccReconciliationLine."Statement No.");
            BankAccRecProposal.SetBankAccountNo(BankAccReconciliationLine."Bank Account No.");
            if BankAccReconciliation.Get(BankAccReconciliationLine."Statement Type", BankAccReconciliationLine."Bank Account No.", BankAccReconciliationLine."Statement No.") then begin
                BankAccRecProposal.SetStatementDate(BankAccReconciliation."Statement Date");
                BankAccRecProposal.SetBalanceLastStatement(BankAccReconciliation."Balance Last Statement");
                BankAccRecProposal.SetStatementEndingBalance(BankAccReconciliation."Statement Ending Balance");
                BankAccRecProposal.SetPageCaption(StrSubstNo(ContentAreaCaptionTxt, BankAccReconciliationLine."Bank Account No.", BankAccReconciliationLine."Statement No.", BankAccReconciliation."Statement Date"));
            end;
            BankAccRecProposal.SetBankAccReconciliationLines(BankAccReconciliationLine);
            BankAccRecProposal.SetTempBankAccLedgerEntryMatchingBuffer(TempBankAccLedgerEntryMatchingBuffer);
            BankAccRecProposal.SetDaysTolerance(DaysTolerance);
            BankAccRecProposal.SetDisableAttachItButton(true);
            BankAccRecProposal.SetSkipNativeAutoMatchingAlgorithm(true);
            BankAccRecProposal.SetGenerateMode();
            BankAccRecProposal.LookupMode(true);
            if BankAccRecProposal.RunModal() = Action::OK then
                Handled := true;
        end;
    end;

    procedure BuildLedgerEntriesFilter(TopLedgerEntries: array[5] of Record "Ledger Entry Matching Buffer"; TopSimilarityScore: array[5] of Decimal): Text;
    var
        TopBankLedgerEntriesFilterTxt: Text;
        MatchThreshold: Decimal;
        i: Integer;
    begin
        MatchThreshold := 0.5;
        for i := 1 to 5 do
            if TopSimilarityScore[i] >= MatchThreshold then begin
                if TopBankLedgerEntriesFilterTxt = '' then
                    TopBankLedgerEntriesFilterTxt := '='
                else
                    TopBankLedgerEntriesFilterTxt += '|';
                TopBankLedgerEntriesFilterTxt += Format(TopLedgerEntries[i]."Entry No.");
            end;
        exit(TopBankLedgerEntriesFilterTxt);
    end;

    [NonDebuggable]
    procedure CreateCompletionAndMatch(CompletionTaskTxt: SecretText; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; DaysTolerance: Integer): Integer
    var
        EmptyText: SecretText;
    begin
        exit(CreateCompletionAndMatch(CompletionTaskTxt, EmptyText, BankAccReconciliationLine, TempBankAccLedgerEntryMatchingBuffer, TempBankStatementMatchingBuffer, DaysTolerance));
    end;

    [NonDebuggable]
    procedure CreateCompletionAndMatch(CompletionTaskTxt: SecretText; UserMessageTxt: SecretText; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; DaysTolerance: Integer): Integer
    var
        AzureOpenAI: Codeunit "Azure OpenAi";
        AOAIDeployments: Codeunit "AOAI Deployments";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        CompletionAnswerTxt: Text;
        NumberOfFoundMatches: Integer;
        NewLineChar: Char;
    begin
        NewLineChar := 10;
        NumberOfFoundMatches := 0;

        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"Bank Account Reconciliation") then
            exit;

        // Generate OpenAI Completion
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", AOAIDeployments.GetGPT41Latest());
        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Bank Account Reconciliation");
        AOAIChatCompletionParams.SetMaxTokens(MaxTokens());
        AOAIChatCompletionParams.SetTemperature(0);
        AOAIChatMessages.AddSystemMessage(CompletionTaskTxt.Unwrap().Replace('\n', NewLineChar));
        if not UserMessageTxt.IsEmpty() then
            AOAIChatMessages.AddUserMessage(UserMessageTxt.Unwrap().Replace('\n', NewLineChar));
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        if AOAIOperationResponse.IsSuccess() then
            CompletionAnswerTxt := AOAIOperationResponse.GetResult()
        else begin
            Session.LogMessage('0000LF7', StrSubstNo(TelemetryChatCompletionErr, AOAIOperationResponse.GetStatusCode()), Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::All, 'Category', FeatureName());
            Error(AOAIOperationResponse.GetError());
        end;

        ProcessCompletionAnswer(CompletionAnswerTxt, BankAccReconciliationLine, TempBankAccLedgerEntryMatchingBuffer, TempBankStatementMatchingBuffer, NumberOfFoundMatches);
        exit(NumberOfFoundMatches);
    end;

    procedure ProcessCompletionAnswer(var CompletionAnswerTxt: Text; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; var NumberOfFoundMatches: Integer)
    var
        MatchedLedgerEntryNoTxt: Text;
        MatchedStatementLineNoTxt: Text;
        MatchJustificationTxt: Text;
        MatchedEntryNo: Integer;
        MatchedLineNo: Integer;
        MatchTripleTxt: Text;
        FirstOpenParenthesisPos: Integer;
        FirstClosedParenthesisPos: Integer;
        CommaPosition: Integer;
    begin
        if CompletionAnswerTxt = '' then
            exit;

        FirstOpenParenthesisPos := StrPos(CompletionAnswerTxt, '(');
        FirstClosedParenthesisPos := StrPos(CompletionAnswerTxt, ')');
        while (FirstOpenParenthesisPos > 0) and (FirstClosedParenthesisPos > FirstOpenParenthesisPos) do begin
            MatchedLedgerEntryNoTxt := '';
            MatchedStatementLineNoTxt := '';
            MatchTripleTxt := CopyStr(CompletionAnswerTxt, FirstOpenParenthesisPos + 1, FirstClosedParenthesisPos - FirstOpenParenthesisPos - 1);
            CompletionAnswerTxt := CopyStr(CompletionAnswerTxt, FirstClosedParenthesisPos + 1);
            FirstOpenParenthesisPos := StrPos(CompletionAnswerTxt, '(');
            FirstClosedParenthesisPos := StrPos(CompletionAnswerTxt, ')');
            if StrPos(MatchTripleTxt, ', [') - 1 > 0 then begin

                MatchedStatementLineNoTxt := CopyStr(MatchTripleTxt, 1, StrPos(MatchTripleTxt, ', [') - 1);
                MatchTripleTxt := CopyStr(MatchTripleTxt, StrPos(MatchTripleTxt, '[') + 1, StrLen(MatchTripleTxt) - StrPos(MatchTripleTxt, '[') - 1);

                while StrLen(MatchTripleTxt) > 0 do begin
                    CommaPosition := StrPos(MatchTripleTxt, ',');
                    if CommaPosition = 0 then begin
                        MatchedLedgerEntryNoTxt := MatchTripleTxt;
                        MatchedLedgerEntryNoTxt := CopyStr(MatchedLedgerEntryNoTxt, 1, StrLen(MatchedLedgerEntryNoTxt));
                        MatchTripleTxt := '';
                    end else begin
                        MatchedLedgerEntryNoTxt := CopyStr(MatchTripleTxt, 1, CommaPosition - 1);
                        MatchTripleTxt := CopyStr(MatchTripleTxt, CommaPosition + 1);
                    end;

                    MatchedLedgerEntryNoTxt := MatchedLedgerEntryNoTxt.Trim();
                    MatchedStatementLineNoTxt := MatchedStatementLineNoTxt.Trim();

                    if MatchIsAcceptable(BankAccReconciliationLine, TempBankAccLedgerEntryMatchingBuffer, MatchedStatementLineNoTxt, MatchedLedgerEntryNoTxt) then begin
                        Evaluate(MatchedEntryNo, MatchedLedgerEntryNoTxt);
                        Evaluate(MatchedLineNo, MatchedStatementLineNoTxt);
                        MatchJustificationTxt := MatchedByCopilotTxt;
                        TempBankStatementMatchingBuffer.Reset();
                        TempBankStatementMatchingBuffer."Entry No." := MatchedEntryNo;
                        TempBankStatementMatchingBuffer."Line No." := MatchedLineNo;
                        TempBankStatementMatchingBuffer."Match Details" := CopyStr(MatchJustificationTxt, 1, MaxStrLen(TempBankStatementMatchingBuffer."Match Details"));
                        if not TempBankStatementMatchingBuffer.Insert() then
                            exit
                        else
                            NumberOfFoundMatches += 1;
                    end;
                end;
            end;
        end;
    end;

    procedure GenerateMatchProposals(var TempBankAccRecAIProposal: Record "Bank Acc. Rec. AI Proposal" temporary; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var TempBankAccLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; DaysTolerance: Integer)
    var
        BankAccReconciliationLineCopy: Record "Bank Acc. Reconciliation Line";
        TopLedgerEntries: array[5] of Record "Ledger Entry Matching Buffer";
        LocalBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        FeatureTelemetry: Codeunit "Feature Telemetry";
        CompletionTaskTxt, UserMessageTxt : SecretText;
        BankRecLedgerEntriesTxt: Text;
        BankRecStatementLinesTxt: Text;
        TopBankLedgerEntriesFilterTxt: Text;
        i, j, CompletePromptTokenCount, TaskPromptTokenCount : Integer;
        SimilarityScore: Decimal;
        TopSimilarityScore: array[5] of Decimal;
        BankRecLineDescription: Text;
        AmountEquals: Boolean;
        EntryAddedToTop5, LedgerEntryBufferFilterSet : Boolean;
        CandidateLedgerEntryNos: List of [Integer];
        FromDate, ToDate : Date;
    begin
        TempBankAccLedgerEntryMatchingBuffer.RESET();
        TempBankStatementMatchingBuffer.RESET();
        BankAccReconciliationLine.SetFilter(Difference, '<>0');

        if not TempBankAccLedgerEntryMatchingBuffer.IsEmpty() then begin
            FeatureTelemetry.LogUptake('0000LF5', FeatureName(), Enum::"Feature Uptake Status"::Used);
            FeatureTelemetry.LogUsage('0000LF6', FeatureName(), 'Match proposals');
            // Initialize the counts
            CompletionTaskTxt := BuildBankRecCompletionTask(true);
            TaskPromptTokenCount := AOAIToken.GetGPT4TokenCount(CompletionTaskTxt);

            // Iterate through each statement line
            BankAccReconciliationLine.FindSet();
            InputWithReservedWordsFound := false;
            repeat
                // Find the top 5 ledger entries closest to the statement line
                TempBankAccLedgerEntryMatchingBuffer.RESET();
                TempBankAccLedgerEntryMatchingBuffer.FindSet();
                FromDate := 0D;
                ToDate := 0D;

                // Initialize TopLedgerEntries and TopSimilarityScore
                for i := 1 to 5 do begin
                    TopLedgerEntries[i].RESET();
                    TopSimilarityScore[i] := 0;
                end;

                repeat
                    BankRecLineDescription := BankAccReconciliationLine.Description;
                    if BankAccReconciliationLine."Additional Transaction Info" <> '' then
                        BankRecLineDescription += (' ' + BankAccReconciliationLine."Additional Transaction Info");
                    if BankAccReconciliationLine."Payment Reference No." <> '' then
                        BankRecLineDescription += (' ' + BankAccReconciliationLine."Payment Reference No.");
                    if BankAccReconciliationLine."Document No." <> '' then
                        BankRecLineDescription += (' ' + BankAccReconciliationLine."Document No.");

                    EntryAddedToTop5 := false;
                    SimilarityScore := ComputeStringNearness(TempBankAccLedgerEntryMatchingBuffer."Description" + ' ' + TempBankAccLedgerEntryMatchingBuffer."Document No." + ' ' + TempBankAccLedgerEntryMatchingBuffer."External Document No.", CopyStr(BankRecLineDescription, 1, 250));
                    AmountEquals := (TempBankAccLedgerEntryMatchingBuffer."Remaining Amount" = BankAccReconciliationLine.Difference);

                    for i := 1 to 5 do
                        if (SimilarityScore > TopSimilarityScore[i]) then begin
                            // Shift the entries down to make room for the new entry
                            for j := 5 downto i + 1 do begin
                                TopLedgerEntries[j] := TopLedgerEntries[j - 1];
                                TopSimilarityScore[j] := TopSimilarityScore[j - 1];
                            end;

                            // Add the new entry
                            TopLedgerEntries[i] := TempBankAccLedgerEntryMatchingBuffer;
                            TopSimilarityScore[i] := SimilarityScore;
                            EntryAddedToTop5 := true;
                            break;
                        end;

                    // make sure to add the entry with equal amount either in the middle or at least as the worst similar of the top 5
                    if not EntryAddedToTop5 and AmountEquals then
                        for i := 1 to 5 do
                            if (TopSimilarityScore[i] = 0) or (i = 5) then begin
                                // Add the new entry
                                TopLedgerEntries[i] := TempBankAccLedgerEntryMatchingBuffer;
                                TopSimilarityScore[i] := 0.5;
                                EntryAddedToTop5 := true;
                                break;
                            end;

                until (TempBankAccLedgerEntryMatchingBuffer.Next() = 0);

                // Generate Prompt using the Statement Line and the Top 5 Ledger Entries
                BankAccReconciliationLineCopy.Copy(BankAccReconciliationLine);
                BankAccReconciliationLineCopy.SetFilter("Statement Line No.", '=%1', BankAccReconciliationLine."Statement Line No.");
                BankAccReconciliationLineCopy.FindSet();
                BuildBankRecStatementLines(BankRecStatementLinesTxt, BankAccReconciliationLineCopy);

                // Apply filters to the ledger entries (TempBankAccLedgerEntryMatchingBuffer) from the top 5 ledger entries.
                TopBankLedgerEntriesFilterTxt := BuildLedgerEntriesFilter(TopLedgerEntries, TopSimilarityScore);
                if TopBankLedgerEntriesFilterTxt = '' then begin
                    LedgerEntryBufferFilterSet := FindDateFilterOnLedgerEntryBuffer(BankRecLedgerEntriesTxt, TempBankAccLedgerEntryMatchingBuffer, CandidateLedgerEntryNos, BankAccReconciliationLineCopy, FromDate, ToDate);
                    TempBankAccLedgerEntryMatchingBuffer.Reset();
                    if FromDate <> 0D then
                        TempBankAccLedgerEntryMatchingBuffer.SetRange("Posting Date", FromDate, ToDate);
                end else begin
                    TempBankAccLedgerEntryMatchingBuffer.SetFilter("Entry No.", TopBankLedgerEntriesFilterTxt);
                    LedgerEntryBufferFilterSet := true;
                end;

                if LedgerEntryBufferFilterSet then
                    if TempBankAccLedgerEntryMatchingBuffer.FindSet() then
                        BuildBankRecLedgerEntries(BankRecLedgerEntriesTxt, TempBankAccLedgerEntryMatchingBuffer, CandidateLedgerEntryNos);

                // if you were unable to set the filter, and your bank ledger entry list is not completely empty
                // just let it be, we have some candidates and we go with them
                // otherwise, throw an error that there are too many entries, we couldn't even build the first candidate list
                if not LedgerEntryBufferFilterSet and (BankRecLedgerEntriesTxt = '') then begin
                    Session.LogMessage('0000OEN', TooManyOpenLedgerEntriesTelemetryErr, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::All, 'Category', FeatureName());
                    Error(TooManyOpenLedgerEntriesErr);
                end;

                CompletePromptTokenCount := TaskPromptTokenCount + AOAIToken.GetGPT4TokenCount(BankRecStatementLinesTxt) + AOAIToken.GetGPT4TokenCount(BankRecLedgerEntriesTxt);
                if (CompletePromptTokenCount >= PromptSizeThreshold()) then begin
                    Session.LogMessage('0000LFK', TelemetryApproximateTokenCountExceedsLimitTxt, Verbosity::Warning, DataClassification::SystemMetadata, TelemetryScope::All, 'Category', FeatureName());
                    UserMessageTxt := BuildBankRecCompletionPromptUserMessage(BankRecStatementLinesTxt, BankRecLedgerEntriesTxt);
                    CreateCompletionAndMatch(CompletionTaskTxt, UserMessageTxt, BankAccReconciliationLine, TempBankAccLedgerEntryMatchingBuffer, TempBankStatementMatchingBuffer, DaysTolerance);
                    BankRecStatementLinesTxt := '';
                    BankRecLedgerEntriesTxt := '';
                    Clear(CandidateLedgerEntryNos);
                end;
            until (BankAccReconciliationLine.Next() = 0);

            // If BankRecStatementLinesTxt and BankRecLedgerEntriesTxt are not empty, then we need to generate a prompt for the remaining records
            if (BankRecStatementLinesTxt <> '') and (BankRecLedgerEntriesTxt <> '') then begin
                UserMessageTxt := BuildBankRecCompletionPromptUserMessage(BankRecStatementLinesTxt, BankRecLedgerEntriesTxt);
                CreateCompletionAndMatch(CompletionTaskTxt, UserMessageTxt, BankAccReconciliationLine, TempBankAccLedgerEntryMatchingBuffer, TempBankStatementMatchingBuffer, DaysTolerance);
            end;

            TempBankStatementMatchingBuffer.Reset();
            if TempBankStatementMatchingBuffer.FindSet() then
                repeat
                    if LocalBankAccountLedgerEntry.Get(TempBankStatementMatchingBuffer."Entry No.") then
                        if BankAccReconciliationLineCopy.Get(BankAccReconciliationLine."Statement Type", BankAccReconciliationLine."Bank Account No.", BankAccReconciliationLine."Statement No.", TempBankStatementMatchingBuffer."Line No.") then
                            if BankAccReconciliationLineCopy.Difference <> 0 then begin
                                TempBankAccRecAIProposal."Statement Type" := BankAccReconciliationLineCopy."Statement Type"::"Bank Reconciliation";
                                TempBankAccRecAIProposal."Bank Account No." := BankAccReconciliationLineCopy."Bank Account No.";
                                TempBankAccRecAIProposal."Statement No." := BankAccReconciliationLineCopy."Statement No.";
                                TempBankAccRecAIProposal."Statement Line No." := TempBankStatementMatchingBuffer."Line No.";
                                TempBankAccRecAIProposal.Description := BankAccReconciliationLineCopy.Description;
                                TempBankAccRecAIProposal."Transaction Date" := BankAccReconciliationLineCopy."Transaction Date";
                                TempBankAccRecAIProposal.Difference := BankAccReconciliationLineCopy.Difference;
                                TempBankAccRecAIProposal.Validate("Bank Account Ledger Entry No.", TempBankStatementMatchingBuffer."Entry No.");
                                TempBankAccRecAIProposal."G/L Account No." := '';
                                TempBankAccRecAIProposal.Insert();
                            end;
                until TempBankStatementMatchingBuffer.Next() = 0;
        end;
    end;

    procedure HasReservedWords(Input: Text): Boolean
    var
        LowerCaseNoSpacesInput: Text;
    begin
        LowerCaseNoSpacesInput := LowerCase(Input).Replace(' ', '');

        if StrPos(LowerCaseNoSpacesInput, '<|im_start|>') > 0 then
            exit(true);

        if StrPos(LowerCaseNoSpacesInput, '<|im_end|>') > 0 then
            exit(true);

        if StrPos(LowerCaseNoSpacesInput, '<|start|>') > 0 then
            exit(true);

        if StrPos(LowerCaseNoSpacesInput, '<|end|>') > 0 then
            exit(true);

        if StrPos(LowerCaseNoSpacesInput, '**task**') > 0 then
            exit(true);

        if StrPos(LowerCaseNoSpacesInput, '[system]') > 0 then
            exit(true);

        if StrPos(LowerCaseNoSpacesInput, 'system:') > 0 then
            exit(true);

        exit(false)
    end;

    procedure ApplyToProposedLedgerEntries(var TempBankAccRecAIProposal: Record "Bank Acc. Rec. AI Proposal" temporary; var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary): Integer
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        MatchBankRecLines: Codeunit "Match Bank Rec. Lines";
        StatementLines: List of [Integer];
    begin
        TempBankStatementMatchingBuffer.DeleteAll();
        TempBankAccRecAIProposal.Reset();
        TempBankAccRecAIProposal.SetFilter("Bank Account Ledger Entry No.", '<>0');
        if TempBankAccRecAIProposal.FindSet() then begin
            repeat
                if BankAccReconciliationLine.Get(TempBankAccRecAIProposal."Statement Type", TempBankAccRecAIProposal."Bank Account No.", TempBankAccRecAIProposal."Statement No.", TempBankAccRecAIProposal."Statement Line No.") then
                    if BankAccountLedgerEntry.Get(TempBankAccRecAIProposal."Bank Account Ledger Entry No.") then begin
                        TempBankStatementMatchingBuffer."Entry No." := BankAccountLedgerEntry."Entry No.";
                        TempBankStatementMatchingBuffer."Line No." := BankAccReconciliationLine."Statement Line No.";
                        TempBankStatementMatchingBuffer."Match Details" := CopyStr(MatchedByCopilotTxt, 1, MaxStrLen(TempBankStatementMatchingBuffer."Match Details"));
                        TempBankStatementMatchingBuffer.Insert();
                        if not StatementLines.Contains(TempBankAccRecAIProposal."Statement Line No.") then
                            StatementLines.Add(TempBankAccRecAIProposal."Statement Line No.");
                    end;
            until TempBankAccRecAIProposal.Next() = 0;
            MatchBankRecLines.SaveManyToOneMatching(TempBankStatementMatchingBuffer, BankAccReconciliationLine."Bank Account No.", BankAccReconciliationLine."Statement No.");
            MatchBankRecLines.SaveOneToOneMatching(TempBankStatementMatchingBuffer, BankAccReconciliationLine."Bank Account No.", BankAccReconciliationLine."Statement No.");
            exit(StatementLines.Count());
        end;
    end;

    procedure FeatureName(): Text
    begin
        exit('Bank Account Reconciliation with AI');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Copilot AI Capabilities", 'OnRegisterCopilotCapability', '', false, false)]
    local procedure HandleOnRegisterCopilotCapability()
    begin
        RegisterCapability();
    end;

    procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        EnvironmentInformation: Codeunit "Environment Information";
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if not EnvironmentInformation.IsSaaSInfrastructure() then
            exit;

        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Bank Account Reconciliation") then begin
            Session.LogMessage('0000OZO', TelemetryAttemptingToRegisterCapabilityTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, 'Category', FeatureName());
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Bank Account Reconciliation", Enum::"Copilot Availability"::"Generally Available", Enum::"Copilot Billing Type"::"Not Billed", LearnMoreUrlTxt);
            if not UpgradeTag.HasUpgradeTag(GetRegisterBankAccRecCopilotGACapabilityUpgradeTag()) then
                UpgradeTag.SetUpgradeTag(GetRegisterBankAccRecCopilotGACapabilityUpgradeTag());
            Commit();
            Session.LogMessage('0000OZP', TelemetrySucceededRegisterCapabilityTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::All, 'Category', FeatureName());
            exit;
        end;

        if UpgradeTag.HasUpgradeTag(GetRegisterBankAccRecCopilotGACapabilityUpgradeTag()) then
            exit;
        CopilotCapability.ModifyCapability(Enum::"Copilot Capability"::"Bank Account Reconciliation", Enum::"Copilot Availability"::"Generally Available", Enum::"Copilot Billing Type"::"Not Billed", LearnMoreUrlTxt);
        UpgradeTag.SetUpgradeTag(GetRegisterBankAccRecCopilotGACapabilityUpgradeTag());
    end;

    local procedure MatchIsAcceptable(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var TempLedgerEntryMatchingBuffer: Record "Ledger Entry Matching Buffer" temporary; MatchedLineNoTxt: Text; MatchedEntryNoTxt: Text): Boolean
    var
        LocalBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        MatchedEntryNo: Integer;
        MatchedLineNo: Integer;
    begin
        if not Evaluate(MatchedEntryNo, MatchedEntryNoTxt) then
            exit(false);

        if not Evaluate(MatchedLineNo, MatchedLineNoTxt) then
            exit(false);

        TempLedgerEntryMatchingBuffer.Reset();
        TempLedgerEntryMatchingBuffer.SetRange("Entry No.", MatchedEntryNo);
        if not TempLedgerEntryMatchingBuffer.FindFirst() then
            exit(false);

        if not LocalBankAccReconciliationLine.Get(BankAccReconciliationLine."Statement Type", BankAccReconciliationLine."Bank Account No.", BankAccReconciliationLine."Statement No.", MatchedLineNo) then
            exit(false);

        if not SameSign(LocalBankAccReconciliationLine.Difference, TempLedgerEntryMatchingBuffer."Remaining Amount") then
            exit(false);

        exit(true)
    end;

    local procedure SameSign(Amount1: Decimal; Amount2: Decimal): Boolean
    begin
        if (Amount1 = 0) or (Amount2 = 0) then
            exit(false);
        exit((Amount1 div Abs(Amount1)) = (Amount2 div Abs(Amount2)));
    end;

    procedure FoundInputWithReservedWords(): Boolean
    begin
        exit(InputWithReservedWordsFound)
    end;

    local procedure GetRegisterBankAccRecCopilotGACapabilityUpgradeTag(): Code[250]
    begin
        exit('MS-521413-RegisterBankAccRecCopilotGACapability-20240624');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure RegisterPerCompanyTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(GetRegisterBankAccRecCopilotGACapabilityUpgradeTag());
    end;

    var
        AOAIToken: Codeunit "AOAI Token";
        MatchedByCopilotTxt: label 'Matched by Copilot based on semantic similarity.', Comment = 'Copilot is a Microsoft service name and must not be translated';
        SuccessfullyFilteredBLEListTxt: label 'Successfully filtered bank account ledger entries based on posting date.', Locked = true;
        UnableToFilterBLEListUnderTokenLimitTxt: label 'Unable to filter the bank account ledger entry list.', Locked = true;
        ConstructingPromptFailedErr: label 'There was an error with sending the call to Copilot. Log a Business Central support request about this.', Comment = 'Copilot is a Microsoft service name and must not be translated';
        TelemetryConstructingPromptFailedErr: label 'There was an error with constructing the chat completion prompt from the Key Vault.', Locked = true;
        TelemetryApproximateTokenCountExceedsLimitTxt: label 'The approximate token count for the Copilot request exceeded the limit. Sending request in chunks.', Locked = true;
        TelemetryAttemptingToRegisterCapabilityTxt: label 'Attempting to register capability Bank Account Reconciliation with Copilot.', Locked = true;
        TelemetrySucceededRegisterCapabilityTxt: label 'Successfully registered capability Bank Account Reconciliation with Copilot.', Locked = true;
        TelemetryChatCompletionErr: label 'Chat completion request was unsuccessful. Response code: %1', Locked = true;
        LearnMoreUrlTxt: Label 'https://go.microsoft.com/fwlink/?linkid=2248547', Locked = true;
        ContentAreaCaptionTxt: label 'Reconciling %1 statement %2 for %3', Comment = '%1 - bank account code, %2 - statement number, %3 - statement date';
        TooManyOpenLedgerEntriesErr: label 'The number of open ledger entries for this bank account exceeds the capacity of data that we can send to Copilot. Open the bank account reconciliation card and use action ''Match Automatically'' to reconcile this statement. Perform the reconciliation month by month - reconciling the oldest open ledger entries first, then moving on to newer ones.';
        TooManyOpenLedgerEntriesTelemetryErr: label 'Throwing error that we are unable to build ledger entry candidate list.', Locked = true;
        InputWithReservedWordsFound: Boolean;
}