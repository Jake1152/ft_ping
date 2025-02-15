#!/usr/bin/env moon

-- ICMP Ping implementation in Moonscript
-- Requires luasocket and bit32 or bit library

socket = require "socket"
bit = bit32 or require "bit"

-- Constants for ICMP
ICMP_ECHO = 8
ICMP_ECHOREPLY = 0
ICMP_TIMEOUT = 1  -- seconds

-- Create checksum for ICMP packet
calculate_checksum = (data) ->
  sum = 0
  count = #data
  i = 1
  
  -- Handle pairs of bytes
  while i < count
    sum += bit.lshift(string.byte(data, i), 8) + string.byte(data, i + 1)
    i += 2
  
  -- Handle last byte if odd length
  if i <= count
    sum += bit.lshift(string.byte(data, i), 8)
  
  -- Add carried bits
  sum = bit.band(sum, 0xFFFF) + bit.rshift(sum, 16)
  sum = bit.band(sum, 0xFFFF) + bit.rshift(sum, 16)
  
  -- Return one's complement
  return bit.bnot(sum) % 0x10000

-- Create an ICMP echo request packet
create_packet = (id, seq, data) ->
  -- Header: type (8), code (0), checksum (0 initially), id, sequence
  header = string.char(ICMP_ECHO, 0, 0, 0) ..
           string.char(bit.rshift(id, 8), bit.band(id, 0xFF)) ..
           string.char(bit.rshift(seq, 8), bit.band(seq, 0xFF))
  
  -- Calculate checksum over header + data
  packet = header .. data
  checksum = calculate_checksum(packet)
  
  -- Replace checksum in the header
  packet = string.char(ICMP_ECHO, 0) ..
           string.char(bit.band(checksum, 0xFF), bit.rshift(checksum, 8)) ..
           string.sub(packet, 5)
  
  return packet

-- Parse ICMP echo reply
parse_reply = (packet, expected_id) ->
  if #packet < 28
    return nil, "Packet too short"
  
  -- Extract ICMP header from IP packet (skip IP header)
  ip_header_length = bit.band(string.byte(packet, 1), 0x0F) * 4
  icmp_packet = string.sub(packet, ip_header_length + 1)
  
  -- Check if it's an echo reply
  icmp_type = string.byte(icmp_packet, 1)
  if icmp_type != ICMP_ECHOREPLY
    return nil, "Not an echo reply (type: #{icmp_type})"
  
  -- Extract ID and sequence
  id = (string.byte(icmp_packet, 5) * 256) + string.byte(icmp_packet, 6)
  seq = (string.byte(icmp_packet, 7) * 256) + string.byte(icmp_packet, 8)
  
  -- Check if ID matches
  if id != expected_id
    return nil, "ID mismatch (expected: #{expected_id}, got: #{id})"
  
  return {
    type: icmp_type
    id: id
    seq: seq
    data: string.sub(icmp_packet, 9)
  }

-- Ping function
ping = (host, count=4) ->
  -- Resolve hostname
  ip = socket.dns.toip(host)
  if not ip
    return nil, "Could not resolve hostname: #{host}"
  
  print "PING #{host} (#{ip})"
  
  -- Create raw socket
  sock, err = socket.udp()
  if not sock
    return nil, "Could not create socket: #{err}"
  
  -- Set socket options for raw ICMP
  success, err = sock\setpeername(ip, 0)
  if not success
    sock\close()
    return nil, "Could not connect to host: #{err}"
  
  -- Use process ID for ICMP ID
  id = os.getpid() or math.random(0, 0xFFFF)
  
  -- Ping statistics
  stats = {
    transmitted: 0
    received: 0
    min_time: nil
    max_time: nil
    sum_time: 0
  }
  
  -- Send echo requests
  for seq = 1, count
    -- Create packet with timestamp data
    data = "moonping " .. os.time()
    packet = create_packet(id, seq, data)
    
    -- Send packet
    start_time = socket.gettime()
    bytes_sent, err = sock\send(packet)
    if not bytes_sent
      print "Error sending packet: #{err}"
      continue
    
    stats.transmitted += 1
    
    -- Wait for reply
    sock\settimeout(ICMP_TIMEOUT)
    reply, err = sock\receive(1024)
    if not reply
      print "Request timeout for icmp_seq=#{seq}"
      continue
    
    end_time = socket.gettime()
    rtt = (end_time - start_time) * 1000  -- convert to milliseconds
    
    -- Parse and validate reply
    reply_info, err = parse_reply(reply, id)
    if not reply_info
      print "Error parsing reply: #{err}"
      continue
    
    -- Update statistics
    stats.received += 1
    stats.sum_time += rtt
    if not stats.min_time or rtt < stats.min_time
      stats.min_time = rtt
    if not stats.max_time or rtt > stats.max_time
      stats.max_time = rtt
    
    -- Print result
    print "#{#reply} bytes from #{ip}: icmp_seq=#{seq} time=#{rtt:.2f} ms"
    
    -- Wait a bit before sending next packet
    if seq < count
      socket.sleep(1)
  
  -- Print summary
  if stats.received > 0
    stats.avg_time = stats.sum_time / stats.received
  else
    stats.avg_time = 0
  
  loss_pct = (1 - stats.received / stats.transmitted) * 100
  print "\n--- #{host} ping statistics ---"
  print "#{stats.transmitted} packets transmitted, #{stats.received} received, #{loss_pct:.1f}% packet loss"
  
  if stats.received > 0
    print "rtt min/avg/max = #{stats.min_time:.3f}/#{stats.avg_time:.3f}/#{stats.max_time:.3f} ms"
  
  sock\close()
  return stats

-- Main function
main = ->
  if #arg < 1
    print "Usage: #{arg[0]} hostname [count]"
    os.exit(1)
  
  host = arg[1]
  count = tonumber(arg[2]) or 4
  
  stats, err = ping(host, count)
  if not stats
    print "Error: #{err}"
    os.exit(1)
  
  -- Exit with appropriate code
  if stats.received == 0
    os.exit(1)
  else
    os.exit(0)

-- Run main function
main()