SET local check_function_bodies = off;

ALTER TABLE "public"."Messages"
  DROP CONSTRAINT "Messages_pkey";

ALTER TABLE "public"."Messages"
  DROP COLUMN "id";

ALTER TABLE "public"."Messages"
  ALTER COLUMN "timestamp" SET NOT NULL;

CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  insert into public.profiles (
    id,
    full_name,
    avatar_url,
    role
  )
  values (
    new.id,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url',
    'user'
  );

  return new;
end;
$function$;

ALTER TABLE "public"."Messages"
  ADD CONSTRAINT "Messages_pkey" PRIMARY KEY ("from", "to", "timestamp");

