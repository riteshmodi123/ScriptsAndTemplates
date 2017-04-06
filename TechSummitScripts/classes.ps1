
enum carColor 
{
    Red
    Orange
    Yellow
    Green
    Blue
    Purple
}

class car {
    [carcolor] $paintColor
    [int] $year
    [string] $make
    [string] $model
    car($paintColor, $year, $make, $model) {
        $this.paintColor = [carcolor]::$paintColor
        $this.year =  $year
        $this.make = $make
        $this.model = $model
    }
    [string]ToString() {
        $stringVersion = $this.paintColor.ToString() + ' ' + $this.year + ' ' + $this.make + ' ' + $this.model
        return $stringVersion
    }
}

$a = [car]::new('Blue', 2010, 'Toyota', 'camry')
$a
$a.ToString()
$a | get-member

function New-car ($paintColor, $Year, $Make, $Model){
    $myCar = [car]::new($paintColor, $Year, $Make, $Model)
    $myCar
}

$b = New-car -paintColor "Red" -Year 2017 -Make Tesla -Model "Model S"
$b


