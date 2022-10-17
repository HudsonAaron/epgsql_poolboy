{application, epgsql_poolboy, [
    {description, "PostgreSQL/OTP + Poolboy"},
    {vsn, "1.0.0"},
    {modules, [epgsql_poolboy_app,epgsql_poolboy_sup]},
    {mod, {epgsql_poolboy_app, []}},
    {applications, [kernel, stdlib]}
]}.