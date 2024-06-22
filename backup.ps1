# ������������ ������ ������
$sourceDirectory = "W:\�����"
$backupDirectory = "D:\backup_tmp"
$archiveDirectory = "D:\backup"
$maxArchiveCount = 5

# ��������� ���������, ���� ���� �� �������
New-Item -ItemType Directory -Force -Path $backupDirectory
New-Item -ItemType Directory -Force -Path $archiveDirectory

# ��������� ������� ���� �� ����
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"

# ��������� �������� "�����" �� �������� "backup_tmp"
Write-Host "��������� ��������..."
Copy-Item -Path $sourceDirectory -Destination $backupDirectory -Recurse -Force

# ��������� ������ � ����������� .zip
$archivePath = Join-Path -Path $archiveDirectory -ChildPath ("�����_$timestamp.zip")
Write-Host "��������� �������� � �����..."
Add-Type -A 'System.IO.Compression.FileSystem'
[IO.Compression.ZipFile]::CreateFromDirectory($backupDirectory, $archivePath)

# ��������� �������� "�����" � �������� "backup_tmp"
Write-Host "��������� ��������..."
Remove-Item -Path $backupDirectory -Recurse -Force

# ���������� ������ �� �������� "backup" � ���������� ���� ������� 5 �����
Write-Host "���������� ������..."
Move-Item -Path $archivePath -Destination $archiveDirectory

# ��������� ������ ������, ���� �� �����, �� $maxArchiveCount
$archives = Get-ChildItem -Path $archiveDirectory -Filter "*.zip" | Sort-Object -Property LastWriteTime -Descending
if ($archives.Count -gt $maxArchiveCount) {
    $archivesToDelete = $archives | Select-Object -Skip $maxArchiveCount
    Write-Host "��������� ������ ������..."
    foreach ($archiveToDelete in $archivesToDelete) {
        Remove-Item -Path $archiveToDelete.FullName -Force
    }
}

Write-Host "�������� ���������."
