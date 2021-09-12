from sympy import *
from sympy.physics.units import *
import pint
ureg = pint.UnitRegistry()

class ParameterCollection(dict):
    def __init__(self):
        self.declaredSymbols = set()
        
    def add(self, name, symbol, expression, unit, description = "none"):
        declaredSymbols = set(map(lambda symbol: str(symbol), list(self.declaredSymbols)))
        
        if symbol in declaredSymbols:
            raise ValueError('Error adding new parameter: Parameter symbol already exists! Choose another name.')
        
        newParameter = Parameter(name, symbol, expression, unit, description, self)
        self[name] = newParameter
        self[symbol] = newParameter
        self.declaredSymbols.add(newParameter.symbol)
        return newParameter
    
class Parameter:
    defaultPrecision = 3
    
    def __init__(self, name, symbol, expression, unit, description, parentCollection):
        self.parentCollection = parentCollection
        self.name = name
        self.symbol = Symbol(symbol)
        globals()[symbol] = self.symbol
        globals()[name] = self.symbol
        
        self.subscriptItalics = []
        self.description = description
        self.descriptionDisplayed = False
        self.unit = ureg(str(unit))
        self.expressionList = []

        self.appendExp(expression)
    
    def appendExp(self, expression):
        self.expressionList.append(sympify(expression, evaluate = False))
        self.dependencies = self.depsFromExp(self.exp())
        self.evaluate()

        if not self.checkDim():
            raise ValueError("Error adding new parameter: User-input units don't match with evaluated units! Please check the dimensionality.")

    def exp(self):
        return self.expressionList[-1]

    def depsFromExp(self, expression):
        unfilteredSymbols = set(expression.atoms(Symbol))
        declaredSymbols = self.parentCollection.declaredSymbols
        return unfilteredSymbols & declaredSymbols
    
    def unwrapExp(self):
        expression = self.exp()
        deps = self.depsFromExp(expression)
        while len(deps) != 0:
                expression = self.substitute(expression, deps)
                deps = self.depsFromExp(expression)
        return expression
    
    def substitute(self, expression, dependencies, forDisplay = False):
        subObject = {}
        for dep in dependencies:
            depName = str(dep)
            depParameter = self.parentCollection[depName]
            depObject = depParameter.exp()
            if forDisplay:
                depObject = UnevaluatedExpr(depParameter.quantity.magnitude)
            subObject[depName] = depObject
        return expression.subs(subObject)
        
    def evaluate(self, precision = defaultPrecision):
        expression = self.unwrapExp().n(precision)
        self.quantity = ureg(str(expression))

    def checkDim(self):
        return (self.quantity.dimensionality == self.unit.dimensionality)

    def hasSelfReference(self, expression):
        deps = self.depsFromExp(expression)
        return self.symbol in deps

    def redefine(self, newExpression):
        deps = set()
        deps.add(self.symbol)
        if self.hasSelfReference(newExpression):
            newExpression = self.substitute(newExpression, deps)
        self.appendExp(newExpression)
        
    def laDeclaration(self):
        return latex(self.symbol)

    def laDefinition(self):
        return latex(self.exp(), mul_symbol = "times")

    def laSubstitution(self):
        expression = self.exp()
        return latex(self.substitute(expression, self.depsFromExp(expression), True), mul_symbol = "times")

    def laEvaluation(self):
        return "{:Lx}".format(self.quantity)

    def wow(self):
        return self.laDeclaration() + " = " + self.laDefinition() + " = " + self.laSubstitution() + " = " + self.laEvaluation()