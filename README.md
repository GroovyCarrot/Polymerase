## GCDependencyInjection

##### A dependency injection framework for iOS and OS X, with easy Storyboard integration, and parameter support.

This framework provides a dependency injection container class
(`GCDIDefinitionContainer`) that has a standardised way of defining services
(objects) within the application. The premise is quite simple: all you have to
do, is inform the container how to construct your service, for when it is
requested. A service may require other services to be injected into it via the
initialiser, or setters.

Services in the container are assigned identifiers, which are used to create
references to them. A service definition is added to the container using the
following code.

```objective-c
[_container setService:@"example_service" definition:^(GCDIDefinition *definition) {
  [definition setClassName:@"MyExampleClass"];
  [definition setInitializer:@"initWithDependency:"];
  [definition setArguments:@[
    [GCDIReference referenceForServiceId:@"dependency_service"],
  ]];
}];
```

It may seem strange to record a class name and a selector as a string;
definitions do have methods that support passing `Class` and `SEL` types if you
wanted to add definitions to the container using code, definitions do still
convert the `Class` into a string. The benefit of recording this data in
string format, means that do not need to use code to store the definitions for
all of our services, and code can be used for actual logic.

### Move over, property list.

One of the biggest advantages of dependency injection, is that it also
centralises where objects are constructed, making it easier for others to
understand how the application works. Service definitions can all be defined in
the one place, using simple key-value recording. While the obvious choice is
property lists, these are a dated, and ugly way of representing basic data - not
to mention requiring specialised software in order to present and manipulate
them in a friendly format.

Cue **YAML language**: a easy to read text format, for storing configuration,
that supports all the basic data types (strings, numbers, dictionaries and 
arrays). A YAML compiler script is bundled with this framework, that you can use
with a build rule, to allow you to write all of your service definitions and
define parameters in YAML format. An Objective C Yaml category implementation
for your container class will be generated, and compiled with your project. This
means that when you call `[[MyContainerClass alloc] init]`, your container will
already have all of your service definitions loaded into it, and be ready to go.

```yaml
# Tell the compiler what class to generate the Yaml category implementation for.
# The compiler by default will use the basename of the YAML file, therefore 
# without this line, you would need to call this file MyContainerClass.yml
ContainerClass: MyContainerClass

# Define parameters that are to be added to the container.
Parameters:
  example.service.class: GCDIExampleService

# Service definitions are listed here.
Services:
  example_service:
    Class: '%example.service.class%' # Reference the above parameter.
    Initializer: initService

  example_injected_service:
    Class: GCDIInjectedExampleService
    Setters:
      'setInjectedService:': '@example_service' # Reference another service.
```

#### Parameters

Parameters are references by using strings enclosed in `%`'s. For example,
`'%example.service.class%'` will resolve to `'GCDIExampleService'` here.
Parameters do not have to be strings, however you are able to substitute string 
parameters within strings (`'I want to %foo%'`).

Dynamic parameters can be added at runtime. For example:

```objective-c
[_container setParameter:@"NSBundle.mainBundle" value:[NSBundle mainBundle]];
```

The above can be called after (or during) initialising the container, however
you can still use `%NSBundle.mainBundle%` as a parameter in the YAML file, as it
will be available when the container is constructing the service.

#### Services

References to other services are created by using strings starting with `@`, 
followed by the name of the service that is being referenced. You can use `@?`
to just pass in `nil`, if the service definition does not exist when the
container is constructing the service; rather than throwing a service not found
exception. You can also escape creating a service reference with `@@` - this 
will just give you a string starting with @.

## Storyboard integration.

Storyboard integration is easily achieved, and all you have to do is tell the
container to inject into storyboards, after initialising it. One important
factor here, is that the container is initialised before the storyboard has been
constructed. Otherwise, the container will not be able to inject dependencies
into your view controllers. The best place to do this is in your AppDelegate's
`- (id)init` method; and assign it to a strong/retained property on your
AppDelegate.

```objective-c
_container = [[MyContainerClass alloc] init];
[_container setContainerInjectsIntoStoryboards:TRUE];
```

In order to have a service injected into your controller, all you need to do is
utilise the _User Defined Runtime Attributes_ interface, in Xcode. By adding
attributes with the _Key Path_ of the property that you would like to inject the
service into, _Type_ `String`, with _Value_ of `@example_service`, the service
will be constructed by the container and injected in. All of the substitutions
available in the YAML file are valid, such as passing parameters with esclosing
`%`'s.

![Storyboard integration](http://groovycarrot.co.uk/sites/gc/files/gcdepedencyinjection-storyboard-integration.png)

***

*Documentation is currently in the process of being put together.*

#### Bugs and feature requests
Please use the [GitHub issues](https://github.com/GroovyCarrot/GCDependencyInjection/issues)
page to raise these.

***

This framework has been largely modelled after the [Symfony dependency injection
component](http://symfony.com/doc/current/components/dependency_injection/introduction.html),
for PHP.

© 2016 [GroovyCarrot](http://groovycarrot.co.uk)
