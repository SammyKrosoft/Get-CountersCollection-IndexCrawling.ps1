<#
This script gets a few samples of counters to collect for a quick-check. It is NOT meant for long-term performance analysis.
For long-term analysis, you can use ExPerfwiz for example at https://github.com/microsoft/ExPerfWiz

.LINK
https://github.com/microsoft/ExPerfWiz

#>
[CmdLetBinding(DefaultParameterSetName = "NormalRun")]
Param(
    [Parameter(Mandatory = $False, Position = 1, ParameterSetName = "NormalRun")] $Server
)


$OutputFile = "c:\temp\CrawlCounters$(get-date -F "yyyMMdd-HHmmss").csv"

#$Server = "E2010"
if ($Server -ne $Null){$Server = ("\\") + $Server}

$Counters = @(
"$Server\MSExchange Search Indexer\Number of Databases Being Crawled",
"$Server\MSExchange Search Indexer\Number of Databases Being Indexed",
"$Server\MSExchange Search Indices(_total)\Age of the Last Notification Indexed",
"$Server\MSExchange Search Indices(_total)\Full Crawl Mode Status",
"$Server\MSExchange Search Indices(_total)\Indexing Slow",
"$Server\MSExchange Search Indices(_total)\Items Reconciled In Current Mailbox",
"$Server\MSExchange Search Indices(_total)\Number of backlogged items added to retry table",
"$Server\MSExchange Search Indices(_total)\Number of Failed Mailboxes",
"$Server\MSExchange Search Indices(_total)\Number of Indexed Recipients",
"$Server\MSExchange Search Indices(_total)\Number of Mailboxes Left to Crawl",
"$Server\MSExchange Search Indices(_total)\Number of Outstanding Batches",
"$Server\MSExchange Search Indices(_total)\Number of Outstanding Crawler Batches",
"$Server\MSExchange Search Indices(*)\Age of the Last Notification Indexed",
"$Server\MSExchange Search Indices(*)\Full Crawl Mode Status",
"$Server\MSExchange Search Indices(*)\Indexing Slow",
"$Server\MSExchange Search Indices(*)\Items Reconciled In Current Mailbox",
"$Server\MSExchange Search Indices(*)\Number of backlogged items added to retry table",
"$Server\MSExchange Search Indices(*)\Number of Failed Mailboxes",
"$Server\MSExchange Search Indices(*)\Number of Indexed Recipients",
"$Server\MSExchange Search Indices(*)\Number of Mailboxes Left to Crawl",
"$Server\MSExchange Search Indices(*)\Number of Outstanding Batches",
"$Server\MSExchange Search Indices(*)\Number of Outstanding Crawler Batches",
"$Server\Processor Information(_Total)\% Processor Time")

Get-Counter -Counter $Counters -MaxSamples 5 | ForEach {
    $_.CounterSamples | ForEach {
        [pscustomobject]@{
            TimeStamp = $_.TimeStamp
            Path = $_.Path
            Value = $_.CookedValue
        }
    }
} | Export-CSV -NoType $OutputFile

notepad $outputfile