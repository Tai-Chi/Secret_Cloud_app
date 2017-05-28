class GetFileSystemList
  def initialize(config)
    @config = config
  end

  def call(username:)
    response = HTTP.post("#{@config.API_URL}/filesystem", json: { username: username })
    @file_system_list = []
    self.DFS(JSON.parse(response.body), []) if response.code == 200
    @file_system_list.shift
    return @file_system_list.sort!
  end

  def DFS(folder, pathUnits)
    if folder.is_a?(Hash)
      @file_system_list.push(pathUnits)# if folder.size > 1
      folder.each do |k, v|
        self.DFS(v, pathUnits.clone.push(k))
      end
    elsif folder.is_a?(String)
      @file_system_list.push(pathUnits)
    end
  end
end
