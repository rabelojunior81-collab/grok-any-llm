@{
    # PSScriptAnalyzer settings — grok-any-llm
    # Severity: Error + Warning (-EnableExit faz falhar em Error; warnings sao informativos).
    Severity = @('Error','Warning')
    Rules    = @{
        # gall.ps1 e um shim CLI: Write-Host e intencional (saida user-facing).
        PSAvoidUsingWriteHost = @{ Enable = $false }
        # Nao exige ShouldProcess em funcoes stateless do shim.
        PSUseShouldProcessForStateChangingFunctions = @{ Enable = $false }
    }
}
