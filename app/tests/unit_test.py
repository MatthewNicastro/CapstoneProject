import pytest

@pytest.fixture
def mock_value():
    return 1

def test_test1(mock_value):
    assert mock_value == 1

def test_test2():
    assert 'hello' == 'hello'

def test_test3(): 
    assert not False