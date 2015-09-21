class NamespaceClasses < ActiveRecord::Migration
  def up
    Provider.where(type: 'Provider::Aws').update_all(type: 'JellyfishAws::Provider::Aws')
    Service.where(type: 'Service::Ec2').update_all(type: 'JellyfishAws::Service::Ec2')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
