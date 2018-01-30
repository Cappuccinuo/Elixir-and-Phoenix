defmodule TestTest do
  use ExUnit.Case
  doctest Primes

  test "check some primes" do
    assert Primes.is_prime?(2)
    assert Primes.is_prime?(3)
    assert !Primes.is_prime?(4)
    assert Primes.is_prime?(5)
    assert !Primes.is_prime?(6)
  end

end
