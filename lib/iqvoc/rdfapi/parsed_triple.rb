# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Iqvoc
  module RDFAPI

    class ParsedTriple
      def initialize(parser, matchdata)
        @parser = parser
        @m = matchdata
      end

      def ok?
        self.subject != :skip and
            self.predicate != :skip and
            self.object != :skip
      end

      def subject
        @subject ||= begin
          if @m[:SubjectNodeName] # blank node
#             Node.find(:name => @m[:SubjectNodeName])
            puts "ignoring blank node #{@m[:SubjectNodeName]} in subject."
            :skip
          elsif @parser.prefixes[@m[:SubjectUriPrefix]] == '' # subject we want to import
#             Node.find(:origin => Iqvoc::Origin.new(@m[:SubjectUriOrigin]).to_s)
            ":#{Iqvoc::Origin.new(@m[:SubjectUriOrigin]).to_s}"
          else
            puts "ignoring unknown prefix #{@m[:SubjectUriPrefix]}."
            :skip
          end
        end
      end

      def predicate
        @predicate ||= begin
          if prefix = @parser.prefixes[@m[:PredicateUriPrefix]] # known prefix
            "#{prefix}:#{@m[:PredicateUriOrigin]}"
          else
            :skip
          end
        end
      end

      def object
        @object ||= begin
          if @m[:ObjectNodeName] # blank node
#             Node.find(:name => @m[:ObjectNodeName])
            puts "ignoring blank node #{@m[:ObjectNodeName]} in object."
            :skip
          elsif prefix = @parser.prefixes[@m[:ObjectUriPrefix]]
#             Node.find(:origin => Iqvoc::Origin.new(@m[:ObjectUriOrigin]).to_s)
            "#{prefix}:#{Iqvoc::Origin.new(@m[:ObjectUriOrigin]).to_s}"
          elsif @m[:ObjectString] # string literal
            @m[:Object]
          else
            :skip
          end
        end
      end

    end # class ParsedTriple
  end # module RDFAPI
end # module Iqvoc