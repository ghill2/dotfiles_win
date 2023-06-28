function ReadLines {
    param (
        [string]$Path
    )
    Get-Content -Path $Path `
        | ForEach-Object { $_.Trim() } `
        | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' } `
        | ForEach-Object {
            $lastIndex = $_.LastIndexOf("#")
            if ($lastIndex -ge 0) {
                $_.Substring(0, $lastIndex)
            } else {
                $_
            }
        } `
        | ForEach-Object { $_.Trim() }
}