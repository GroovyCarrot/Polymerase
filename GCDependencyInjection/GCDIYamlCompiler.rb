#!/usr/bin/env ruby

require 'yaml'

def resolveServices(value)
  if value.is_a? Array
    resolved = []
    value.each do|val|
      resolved.push(resolveServices(val))
    end
    return '@[' + resolved.join(', ') + ']'
  elsif value.is_a? Hash
    resolved = '@{'
    value.each do|key, val|
      resolved += '@"' + key + '": ' + resolveServices(val) + ', '
    end
    return resolved[0, resolved.length - 2] + '}'
  elsif value.is_a?(String) && value[0, 1] == '@'
    service = nil
    invalidBehaviour = nil

    if value[0, 2] == '@@'
      return '@"' + value[1, value.length - 1] + '"'
    elsif value[0, 2] == '@?'
      service = value[2, value.length - 2]
      invalidBehaviour = 'kNilOnInvalidReference'
    else
      service = value[1, value.length - 1]
      invalidBehaviour = 'kExceptionOnInvalidReference'
    end

    return '[GCDIReference referenceForServiceNamed:@"' + service + '" invalidBehaviourType:' + invalidBehaviour + ']'
  end
  return '@"' + value + '"'
end

def parseServiceDefinition(variable, definition, indent)
  output = []

  if definition['Class']
    output.push('[' + variable + ' setKlass:@"' + definition['Class'] + '"];')
  end

  if definition['Selector']
    output.push('[' + variable + ' setSelector:@selector(' + definition['Selector'] + ')];')
  end

  if definition['Arguments']
    output.push('[' + variable + ' setArguments:' + resolveServices(definition['Arguments']) + '];')
  end

  if definition['Properties']
    output.push('[' + variable + ' setProperties:' + resolveServices(definition['Properties']) + '];')
  end

  if definition['MethodCalls']
    definition['MethodCalls'].each do|methodCall|
      output.push('[' + variable + ' addMethodCall:[GCDIMethodCall methodCallForSelector:@selector(' + methodCall['Selector'] + ') andArguments:' + resolveServices(methodCall['Arguments']) + ']];')
    end
  end

  if definition['Tags']
    output.push('[' + variable + ' setTags:' + resolveServices(definition['Tags']) + '];')
  end

  indent =  (' ' * indent)
  return indent + output.join("\n" + indent)
end

if !File.exists?(File.expand_path(ARGV[0])) || !ARGV[1]
  puts 'Usage: GCDIYamlCompiler [input.yaml] [output.m]'
  if ARGV[0]
    puts '       File ' + ARGV[0] + ' not found.'
  end
  if !ARGV[1]
    puts '       Missing output file.'
  end
  exit
end

klass = File.basename(ARGV[0], '.*')
instruction = YAML.load_file(ARGV[0])
output = File.open(ARGV[1], 'w+');

output.puts '#import "' + klass + '.h"'
output.puts '#import <GCDependencyInjection/GCDependencyInjection.h>'
output.puts ''
output.puts '@implementation ' + klass
output.puts ''
output.puts '- (id)init {'
output.puts '  self = [super init];'
output.puts '  if (!self) {'
output.puts '    return nil;'
output.puts '  }'
output.puts ''

if instruction['Parameters'].is_a?(Hash)
  instruction['Parameters'].each do|parameter, value|
    output.puts '  [self setParameter:@"' + parameter + '" value:' + resolveServices(value) + '];'
  end
end

if instruction['Services'].is_a?(Hash)
  output.puts '  GCDIDefinition *serviceDefinition;'
  instruction['Services'].each do|service, definition|
    if definition.is_a?(String)
      if definition[0, 1] == '@'
        output.puts '  [self setAlias:@"' + service + '" to:@"' + definition[1, definition.length - 1] + '"];'
      end
    else
      output.puts '  serviceDefinition = [[GCDIDefinition alloc] init];'
      output.puts parseServiceDefinition('serviceDefinition', definition, 2)
      output.puts '  [self setDefinition:serviceDefinition forService:@"' + service + '"];'
    end
  end
end

output.puts ''
output.puts '  return self;'
output.puts '}'
output.puts ''
output.puts '@end'

puts 'Output ' + klass + ' implementation to ' + ARGV[1]
