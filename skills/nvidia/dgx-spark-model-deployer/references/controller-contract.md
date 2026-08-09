# Controller Contract

## Configuration block

Place near the top:

```text
model ID and revision
served model name
runtime image/repository/commit
master and worker addresses
cache/model paths
context and concurrency
GPU-memory utilization
KV-cache dtype
tool/reasoning parsers
modalities
API port and key
timeouts
```

## Commands

At minimum:

```text
download
verify-files
start
stop
restart
status
logs
client-config
```

Add runtime preparation, sync, parser tests, multimodal tests, benchmark, and stress commands as required.

## Download

- use persistent host storage;
- support resume;
- pin revision;
- avoid downloading backup/calibration artifacts unless required;
- parse indexes instead of hard-coding shards;
- preserve Hugging Face `blobs`, `refs`, and `snapshots` when symlink-based caches are used.

## Verification

Check:

- expected revision;
- required small files;
- all indexed shards;
- broken symlinks;
- architecture and context;
- quantization metadata;
- chat-template markers;
- parser availability;
- checksums or a locally sealed manifest.

For multiple nodes, compare paths, symlink targets, sizes, and SHA-256 hashes.

## Start

- stop or reject conflicting API ports;
- verify host and fresh-container GPU access;
- verify runtime lock;
- verify files;
- mount cache read/write only where needed;
- mount templates and media read-only;
- wait for `/health`;
- print base URL, model name, context, and topology.

## Status

Show:

```text
configuration
runtime lock
container/process state
GPU memory/utilization
distributed cluster state
API health
models endpoint
```

## Tests

Use non-destructive synthetic fixtures. Tool tests must not execute model-requested tools unless the user explicitly runs a sandboxed harness.


## Bash numeric and size rules

Do not use underscore separators in pure numeric Bash literals:

```bash
# Invalid in Bash arithmetic
(( size > 25_000_000_000 ))

# Valid
MIN_SIZE_BYTES="25000000000"
(( size > MIN_SIZE_BYTES ))
```

When exact repository metadata is available, do not rely only on a lower bound. Check exact byte size, file magic where applicable, and SHA-256.

## Context, port, and network contract

Single-node and stacked API controllers should accept:

```text
--context TOKENS
--port PORT
--bind ADDRESS
--advertise-ip ADDRESS
--interface NAME
--client-input TOKENS|auto
--client-output TOKENS
```

Environment variables must also work.

Keep these concepts separate:

```text
bind address
advertised client address
cluster transport address
```

For automatic advertised-address selection:

1. explicit advertised IP;
2. explicit interface;
3. `ip route get` source address;
4. first non-virtual global IPv4;
5. `hostname -I` only as a last fallback.

Stacked controllers may retain fixed or configurable Master/Worker transport IPs, but must not automatically publish the cluster-only IP as the client endpoint.
