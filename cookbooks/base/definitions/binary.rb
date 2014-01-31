
define :remote_archive, :owner => "root", :group => "root", :source => false, :dest => false do
  if params[:source] && params[:dest] then
    bn=::File.basename(params[:source])
    dn=::File.dirname(params[:dest])
    remote_file "#{Chef::Config[:file_cache_path]}/#{bn}" do
      source params[:source]
      action :create
    end
    directory "mkdir-#{params[:dest]}" do
      not_if {::File.directory?(dn)}
      owner params[:owner]
      group params[:group]
      path dn
      mode 0755
      recursive true
      action :create
    end
    bash "extract-#{bn}" do
      not_if {::File.exists?(params[:dest])}
      cwd dn
      code <<-EOH
tempd=$(mktemp -d --tmpdir=#{dn})
tar xfa #{Chef::Config[:file_cache_path]}/#{bn} -C \$tempd
if [ $(ls -1 $tempd | wc -l) != 1 ] ; then
  mkdir "#{params[:dest]}"
fi
mv $tempd/* "#{params[:dest]}"
rmdir $tempd
chown -R "#{params[:owner]}:#{params[:group]}" "#{params[:dest]}"
chmod -R a+rX "#{params[:dest]}"
EOH
    end
  end
end
