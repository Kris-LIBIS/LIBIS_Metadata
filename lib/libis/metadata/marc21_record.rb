# coding: utf-8

require 'cgi'

require_relative 'marc_record'

module Libis
  module Metadata

    # This class implements the missing private method 'get_all_records' to accomodate for the MARC-XML format.
    class Marc21Record < Libis::Metadata::MarcRecord

      private

      def get_all_records

        @all_records.clear

        @node.xpath('.//leader').each {|f|
          @all_records['LDR'] << FixField.new('LDR', f.content)
        }

        @node.xpath('.//controlfield').each {|f|
          tag = f['tag']
          tag = '%03d' % tag.to_i if tag.size < 3
          @all_records[tag] << FixField.new(tag, f.content)
        }

        @node.xpath('.//datafield').each {|v|

          tag = v['tag']
          tag = '%03d' % tag.to_i if tag.size < 3

          varfield = VarField.new(tag, v['ind1'].to_s, v['ind2'].to_s)

          v.xpath('.//subfield').each {|s| varfield.add_subfield(s['code'], s.content)}

          @all_records[tag] << varfield

        }

        @all_records

      end

    end

  end
end