BeforeAll {
    . $PSCommandPath.Replace('.tests.ps1','.ps1')
}
Describe "Add Log Output" {
    It "Adds Content" {
        $LogFile = "TestDrive:\test_log.txt"
        $LineNumber = "1"
        $Message = "Log Message"
        Add-LogEntry -LogPath $LogFile -Message $Message -LineNumber $LineNumber
        "TestDrive:\test_log.txt" | Should -FileContentMatch "Log Message"
    }

}