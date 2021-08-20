BeforeAll {
    . $PSCommandPath.Replace('.tests.ps1','.ps1')
}
Describe "Start Log Output" {
    It "Adds Content" {
        $LogPath = "TestDrive:\"
        $LogName = "test_log.txt"
        Start-Log -LogPath $LogPath -LogName $LogName -ScriptVersion 1
        "TestDrive:\test_log.txt" | Should -FileContentMatch "Started"
    }

}