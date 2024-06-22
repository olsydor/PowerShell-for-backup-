# Встановлення змінних шляхів
$sourceDirectory = "W:\чиста"
$backupDirectory = "D:\backup_tmp"
$archiveDirectory = "D:\backup"
$maxArchiveCount = 5

# Створення директорій, якщо вони не існують
New-Item -ItemType Directory -Force -Path $backupDirectory
New-Item -ItemType Directory -Force -Path $archiveDirectory

# Отримання поточної дати та часу
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"

# Копіювання каталогу "чиста" до директорії "backup_tmp"
Write-Host "Копіювання каталогу..."
Copy-Item -Path $sourceDirectory -Destination $backupDirectory -Recurse -Force

# Створення архіву з розширенням .zip
$archivePath = Join-Path -Path $archiveDirectory -ChildPath ("чиста_$timestamp.zip")
Write-Host "Стиснення каталогу в архів..."
Add-Type -A 'System.IO.Compression.FileSystem'
[IO.Compression.ZipFile]::CreateFromDirectory($backupDirectory, $archivePath)

# Видалення каталогу "чиста" з директорії "backup_tmp"
Write-Host "Видалення каталогу..."
Remove-Item -Path $backupDirectory -Recurse -Force

# Переміщення архіву до директорії "backup" і збереження лише останніх 5 версій
Write-Host "Збереження архіву..."
Move-Item -Path $archivePath -Destination $archiveDirectory

# Видалення зайвих архівів, якщо їх більше, ніж $maxArchiveCount
$archives = Get-ChildItem -Path $archiveDirectory -Filter "*.zip" | Sort-Object -Property LastWriteTime -Descending
if ($archives.Count -gt $maxArchiveCount) {
    $archivesToDelete = $archives | Select-Object -Skip $maxArchiveCount
    Write-Host "Видалення зайвих архівів..."
    foreach ($archiveToDelete in $archivesToDelete) {
        Remove-Item -Path $archiveToDelete.FullName -Force
    }
}

Write-Host "Операції завершено."
