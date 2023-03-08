import { serve } from "https://deno.land/std@0.178.0/http/server.ts";
const port = 8000;

function handler(/* req: Request */): Response {
  return new Response(JSON.stringify({ time: new Date() }));
}

serve(handler, { port });
