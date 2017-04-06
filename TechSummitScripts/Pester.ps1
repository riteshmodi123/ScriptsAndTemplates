

function sum([int]$a, [int]$b){

    return $a + $b
}

Describe "testing SUM"{
    It "adding two positive numbers" {
        sum -a 10 -b 20 | Should be 30
    }

    It "adding two negative numbers" {
        sum -a -10 -b -20 | Should be -30
    }

    It "adding both types of numbers" {
        sum -a -10 -b 20 | Should be 10
    }
}