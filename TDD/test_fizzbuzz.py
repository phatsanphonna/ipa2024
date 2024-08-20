import pytest
from fizzbuzz import fizzbuzz


@pytest.mark.num
def test_num(setup_teardown):
    assert fizzbuzz(1) == 1
    assert fizzbuzz(2) == 2
    assert fizzbuzz(4) == 4
    assert fizzbuzz(7) == 7
    print('test_num passed')


@pytest.mark.fizz
def test_fizz(setup_teardown):
    assert fizzbuzz(3) == 'Fizz'
    assert fizzbuzz(6) == 'Fizz'
    assert fizzbuzz(9) == 'Fizz'
    assert fizzbuzz(12) == 'Fizz'
    print('test_fizz passed')


@pytest.mark.buzz
def test_buzz(setup_teardown):
    assert fizzbuzz(5) == 'Buzz'
    assert fizzbuzz(10) == 'Buzz'
    assert fizzbuzz(20) == 'Buzz'
    assert fizzbuzz(25) == 'Buzz'
    print('test_buzz passed')


@pytest.mark.fizzbuzz
def test_fizzbuzz(setup_teardown):
    assert fizzbuzz(15) == 'FizzBuzz'
    assert fizzbuzz(30) == 'FizzBuzz'
    assert fizzbuzz(45) == 'FizzBuzz'
    assert fizzbuzz(60) == 'FizzBuzz'
    print('test_fizzbuzz passed')


if __name__ == '__main__':
    test_num()
    test_fizz()
    test_buzz()
    test_fizzbuzz()
