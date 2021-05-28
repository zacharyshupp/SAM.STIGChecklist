# [Variables] -----------------------------------------------------------------------------------------------------

[String]$SAMRoot = $PSScriptRoot
[String]$cklSchemaPath = [IO.Path]::Combine("$SAMRoot", 'Data', 'U_Checklist_Schema_V2.xsd')
[String]$regexFQDN = "^(?!.*?_.*?)(?!(?:[\w]+?\.)?\-[\w\.\-]*?)(?![\w]+?\-\.(?:[\w\.\-]+?))(?=[\w])(?=[\w\.\-]*?\.+[\w\.\-]*?)(?![\w\.\-]{254})(?!(?:\.?[\w\-\.]*?[\w\-]{64,}\.)+?)[\w\.\-]+?(?<![\w\-\.]*?\.[\d]+?)(?<=[\w\-]{2,})(?<![\w\-]{25})$"
[String]$regexMAC = "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})|([0-9a-fA-F]{4}\\.[0-9a-fA-F]{4}\\.[0-9a-fA-F]{4})$"

# [Functions] -----------------------------------------------------------------------------------------------------