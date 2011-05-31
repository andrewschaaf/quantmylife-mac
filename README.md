

## Signal Encoding

<pre>
// initial utc_ms_delta: 0
uvarint(utc_ms_delta) + uvarint(payload.length) + payload
</pre>

### front-app
<pre>
payload = JSON({"pid": 123, "app": "com.example.Foo"})

(only log when there's a change)
</pre>


### front-thing
<pre>
payload = JSON({"url": "file://localhost/Users/satoshi/Desktop/foo.txt"})

(only log when there's a change)
</pre>


### input-idle
<pre>
payload =
    0x01 for BECAME_ACTIVE
    0x02 for BECAME_IDLE

(only log when there's a change)
</pre>


### mouse-position
<pre>
// initial x, y: 0
payload = uvarint(x_delta) + uvarint(y_delta)

(only log when there's a change)
</pre>
