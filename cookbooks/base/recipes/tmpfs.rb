
#file "/etc/fstab" do
#  rc=Chef::Util::FileEdit.new(path)
#  rc.insert_line_if_no_match("^tmpfs /tmp tmpfs defaults 0 0$", "tmpfs /tmp tmpfs defaults 0 0")
#  content rc.send(:contents).join
#end

mount "/tmp" do
  pass 0
  fstype "tmpfs"
  device "none"
  #action [:mount, :enable]
  action :enable
end
