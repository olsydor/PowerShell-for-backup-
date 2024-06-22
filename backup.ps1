# Кодування: UTF-8 без BOM

# Setting path variables
# Встановлення змінних шляхів
$sourceDirectory = "W:\чиста"
$backupDirectory = "D:\backup_tmp"
$archiveDirectory = "D:\backup"
$maxArchiveCount = 5

# Creating directories if they do not exist
# Створення директорій, якщо вони не існують
New-Item -ItemType Directory -Force -Path $backupDirectory
New-Item -ItemType Directory -Force -Path $archiveDirectory

# Getting the current date and time
# Отримання поточної дати та часу
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"

# Copying the "чиста" directory to "backup_tmp"
# Копіювання каталогу "чиста" до директорії "backup_tmp"
Write-Host "Копіювання каталогу..."
Copy-Item -Path $sourceDirectory -Destination $backupDirectory -Recurse -Force


# Creating a .zip archive
# Створення архіву з розширенням .zip
$archivePath = Join-Path -Path $archiveDirectory -ChildPath ("чиста_$timestamp.zip")
Write-Host "Стиснення каталогу в архів..."
Add-Type -A 'System.IO.Compression.FileSystem'
[IO.Compression.ZipFile]::CreateFromDirectory($backupDirectory, $archivePath)

# Deleting the "чиста" directory from "backup_tmp"
# Видалення каталогу "чиста" з директорії "backup_tmp"
Write-Host "Видалення каталогу..."
Remove-Item -Path $backupDirectory -Recurse -Force

# Moving the archive to the "backup" directory and keeping only the last 5 versions
# Переміщення архіву до директорії "backup" і збереження лише останніх 5 версій
Write-Host "Збереження архіву..."
Move-Item -Path $archivePath -Destination $archiveDirectory

# Deleting excess archives if there are more than $maxArchiveCount
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
# Write-Host "Operations completed."
