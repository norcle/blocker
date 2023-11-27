# Проверяем, является ли текущий пользователь суперпользователем
unless Process.uid == 0
  puts "Требуются права суперпользователя для изменения файла /etc/hosts."
  exit 1
end

# Имя файла hosts
hosts_file = '/etc/hosts'

# Домены, которые нужно заблокировать
domains_to_block = ['youtube.com', 'www.youtube.com', 'pikabu.ru', 'www.pikabu.ru']

# IP-адрес для блокировки
blocking_ip = '0.0.0.0'

# Удаляем записи из файла hosts
domains_to_block.each do |domain|
  entry_to_remove = "#{blocking_ip} #{domain}"
  lines = File.readlines(hosts_file)
  new_lines = lines.reject { |line| line.include?(entry_to_remove) }
  File.open(hosts_file, 'w') { |file| file.puts(new_lines) }
  puts "Запись удалена из файла #{hosts_file}: #{entry_to_remove}"
end

# Ждем 3 минуты перед удалением записей
sleep(600)


# Добавляем каждую запись в файл hosts
domains_to_block.each do |domain|
  entry = "#{blocking_ip} #{domain}"

  # Проверяем, есть ли уже такая запись в файле
  if File.readlines(hosts_file).grep(/#{Regexp.quote(entry)}/).empty?
    # Добавляем запись в конец файла
    File.open(hosts_file, 'a') { |file| file.puts(entry) }
    puts "Добавлена запись в файл #{hosts_file}: #{entry}"
  else
    puts "Запись уже существует в файле #{hosts_file}: #{entry}"
  end
end