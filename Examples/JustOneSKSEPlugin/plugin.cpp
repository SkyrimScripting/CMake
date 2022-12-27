#include <SkyrimScripting/Plugin.h>

OnInit { logger::info("Hello from {}", SKSE::PluginDeclaration::GetSingleton()->GetName()); }
