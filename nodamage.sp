
#include <sourcemod>
#include <sdkhooks>

public Plugin:myinfo =
{
   name = "No Damage",
   author = "Dennis Kupec",
   description = "Prevents player damage.",
   version = "1.0",
   url = "https://github.com/denniskupec"
}

public OnPluginStart()
{  
   for (new client = 1; client <= MaxClients; client++) {
      if(IsValidClient(client)) {
         SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
         SDKHook(client, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
      }
   }
}

public OnClientPutInServer(client)
{
   SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
   SDKHook(client, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
}

public Action:OnTakeDamage(client, &attacker, &inflictor, &Float:damage, &damagetype)
{
   SetEntProp(client, Prop_Data, "m_takedamage", 1);
   return Plugin_Continue;
}

public Action:OnTakeDamagePost(client, &attacker, &inflictor, &Float:damage, &damagetype)
{  
   SetEntProp(client, Prop_Data, "m_takedamage", 2);
   return Plugin_Continue;
}

stock bool:IsValidClient(client, bool:bCheckAlive=true)
{
   if(client < 1 || client > MaxClients)
      return false;
   if(!IsClientInGame(client))
      return false;
   if(IsClientSourceTV(client) || IsClientReplay(client))
      return false;
   if(bCheckAlive)
      return IsPlayerAlive(client);
   return true;
}
