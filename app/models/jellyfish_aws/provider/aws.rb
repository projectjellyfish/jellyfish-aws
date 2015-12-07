module JellyfishAws
  module Provider
    class Aws < ::Provider
      def ec2_flavors
        ec2_client.flavors.map do |f|
          {
            id: f.id, name: f.name, bits: f.bits, cores: f.cores, ram: f.ram,
            label: [f.name, f.id].join(' - '), value: f.id
          }
        end
      end

      def rds_engines
        rds_client.describe_db_engine_versions.body['DescribeDBEngineVersionsResult']['DBEngineVersions'].map do |e|
          {
            value: e['Engine'].strip,
            label: e['Engine'].strip
          }
        end.uniq
      end

      def rds_versions(engine)
        return if engine.nil? || engine == 'none'
        rds_client.describe_db_engine_versions({:engine=>engine}).body['DescribeDBEngineVersionsResult']['DBEngineVersions'].map do |e|
          {
            value: e['EngineVersion'].strip,
            label: e['EngineVersion'].strip,
          }
        end
      end

      def rds_flavors(engine, version)
        return [] if engine.nil? || engine == 'none'
        rds_client.describe_orderable_db_instance_options(engine, {:engine_version=>version}).body['DescribeOrderableDBInstanceOptionsResult']['OrderableDBInstanceOptions'].map do |f|
          {
            value: f['DBInstanceClass'].strip,
            label: f['DBInstanceClass'].strip
          }
        end.uniq.sort_by { |f| f[:value] }
      end

      def ec2_images
        case settings[:region]
        when 'us-east-1'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-1ecae776' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-12663b7a' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-aeb532c6' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-d05e75b8' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-f70cdd9c' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-1ccae774' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-c08fcba8' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-d85e75b0' }
          ]
        when 'us-west-1'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-e7527ed7' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-4dbf9e7d' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-d7450be7' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-5189a661' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-c3b3b1f3' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-ff527ecf' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-5df2ab6d' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-6989a659' }
          ]
        when 'us-west-2'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-d114f295' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-a540a5e1' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-b95b4ffc' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-df6a8b9b' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-3bee1c7f' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-d514f291' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-fe8891bb' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-d16a8b95' }
          ]
        when 'eu-west-1'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-a10897d6' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-25158352' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-e801af9f' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-47a23a30' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-68347d1f' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-bf0897c8' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-17c44860' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-5da23a2a' }
          ]
        when 'eu-central-1'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-a8221fb5' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-dafdcfc7' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-a22610bf' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-accff2b1' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-f64540eb' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-ac221fb1' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-fc0033e1' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-b6cff2ab' }
          ]
        when 'ap-southeast-1'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-68d8e93a' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-dc1c2b8e' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-84b392d6' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-96f1c1c4' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-b89093ea' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-acd9e8fe' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-3cbe956e' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-e8f1c1ba' }
          ]
        when 'ap-northeast-1'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-cbf90ecb' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-b1b458b1' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-d54a79d4' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-936d9d93' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-e69520e6' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-27f90e27' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-5cb8a65d' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-8d6d9d8d' }
          ]
        when 'ap-southeast-2'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-fd9cecc7' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-d3daace9' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-b90e6283' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-69631053' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-2d2d6b17' },
            { label: 'Amazon Linux AMI 2015.03 (PV)', value: 'ami-ff9cecc5' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-ad0d7997' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-7163104b' }
          ]
        when 'sa-east-1'
          [
            { label: 'Amazon Linux AMI 2015.03 (HVM), SSD Volume Type', value: 'ami-b52890a8' },
            { label: 'Red Hat Enterprise Linux 7.1 (HVM), SSD Volume Type', value: 'ami-09e25b14' },
            { label: 'SUSE Linux Enterprise Server 12 (HVM), SSD Volume Type', value: 'ami-f102b6ec' },
            { label: 'Ubuntu Server 14.04 LTS (HVM), SSD Volume Type', value: 'ami-4d883350' },
            { label: 'Microsoft Windows Server 2012 R2 Base', value: 'ami-87f8779a' },
            { label: 'Amazon Linux AMI 2015.03 (PV', value: 'ami-bb2890a6' },
            { label: 'SUSE Linux Enterprise Server 11 SP3 (PV), SSD Volume Type', value: 'ami-23912d3e' },
            { label: 'Ubuntu Server 14.04 LTS (PV), SSD Volume Type', value: 'ami-55883348' }
          ]
        else
          []
        end
      end

      def vpcs
        ec2_client.vpcs.map { |x| { label: "#{x.id} (#{x.tenancy})", value: x.id } }
      end

      def subnets(vpc_id)
        ec2_client.subnets.map do |s|
          next unless s.vpc_id == vpc_id
          {
            id: s.subnet_id, name: s.cidr_block, cidr: s.cidr_block, vpc_id: s.vpc_id,
            label:  "#{s.subnet_id} (#{s.cidr_block})",value: s.subnet_id
          }
        end.compact
      end

      def availability_zones
        ec2_client.describe_availability_zones.body['availabilityZoneInfo'].map do |az|
          next unless client.region == az['regionName']
          { label: az['zoneName'], value: az['zoneName'] }
        end.compact
      end

      def key_names
        ec2_client.describe_key_pairs.body['keySet'].map do |kn|
          { label: kn['keyName'], value: kn['keyName']}
        end.compact
      end

      def security_groups
        ec2_client.describe_security_groups.body['securityGroupInfo'].map do |sg|
          { label: "#{sg['groupId']} (#{sg['groupName'][0...30]})", value: sg['groupId']}
        end.compact
      end

      def deprovision(service_id)
        # TODO: REMOVE DEPENDENCY ON DELAYED JOBS
        service = ::Service.where(id: service_id).first
        service.delay.deprovision unless service.nil?

        # TODO: SHOULD THIS BE TURNED INTO A REUSABLE FUNCTION?
        # SUCCESS OR FAIL NOTIFICATION
        service.status = ::Service.defined_enums['status']['stopping']
        service.status_msg = 'stopping'
        service.save

        [ 'Service has been scheduled for deprovisioning.' ]
      end

      def ec2_client
        @ec2_client ||= begin
          Fog::Compute.new credentials
        end
      end

      def s3_client
        @s3_client ||= begin
          Fog::Storage.new credentials
        end
      end

      def rds_client
        @rds_client ||= begin
          # RDS ISSUES A WARNING IF PROVIDER IS PASSED
          Fog::AWS::RDS.new credentials.except(:provider)
        end
      end

      private

      def credentials
        @credentials ||= begin
          {
            provider: 'AWS',
            aws_access_key_id: settings[:access_id],
            aws_secret_access_key: settings[:secret_key],
            region: settings[:region]
          }
        end
      end
    end
  end
end
