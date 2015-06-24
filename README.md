Pooly
=====

> Definition of POOLY
>
>   having many pools
>
> – Merriam-Webster Dictionary

_Pooly_ is a worker pool library inspired by other Erlang worker pool libraries such as [poolboy](https://github.com/devinus/poolboy), [pooler](https://github.com/seth/pooler) and [ppool](http://learnyousomeerlang.com/building-applications-with-otp) (from [Chapter 18](http://learnyousomeerlang.com/building-applications-with-otp) of _Learn You Some Erlang For Great Good_).

The whole point of this exercise is to make this project a part of the example project in Chapter 6 of the [book](http://www.exotpbook.com).

## NOTE: WIP, NOTHING TO SEE HERE

## API 

```elixir
alias Pooly, as: P

P.start_link
P.stop
```

### Starting a pool

This creates a named pool, attach it to the top-level supervisor and starts a bunch of workers (according to `worker_args`).

### Worker Arguments

```elixir
P.start_pool(pool_config)
P.stop_pool(pool)
```

where `pool_config` consists of:

```
name:          the pool name
start_mfa:     the module, function and arguments to start the workers
size:          maximum pool size
max_overflow:  maximum number of workers created if pool is empty
```

### Getting workers

```elixir
P.sync_checkout(pool, timeout)
P.async_checkout(pool, timeout)
P.checkin(pool, worker)
P.transaction(pool, fun, timeout)
P.status(pool)
```

### Setting up a static supervision tree

Should be able to read in a configuration file _something_ like this:


```erlang
{application, example, [
    {description, "An example application"},
    {vsn, "0.1"},
    {applications, [kernel, stdlib, sasl, crypto, ssl]},
    {modules, [example, example_worker]},
    {registered, [example]},
    {mod, {example, []}},
    {env, [
        {pools, [
            {pool1, [
                {size, 10},
                {max_overflow, 20}
            ], [
                {hostname, "127.0.0.1"},
                {database, "db1"},
                {username, "db1"},
                {password, "abc123"}
            ]},
            {pool2, [
                {size, 5},
                {max_overflow, 10}
            ], [
                {hostname, "127.0.0.1"},
                {database, "db2"},
                {username, "db2"},
                {password, "abc123"}
            ]}
        ]}
    ]}
]}.
```

Note: This is in Erlang, Elixir version coming soon, once I figured everything out.
