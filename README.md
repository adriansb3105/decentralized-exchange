# Creación de un Exchange Descentralizado Simple con Pools de Liquidez

## 📚 Descripción del Proyecto
Este proyecto consiste en desplegar contratos inteligentes en la red **Scroll Sepolia** para implementar un exchange descentralizado simple (DEX) que permita intercambiar dos tokens ERC-20.

La solución incluye:

✅ **Añadir liquidez:** El owner puede depositar pares de tokens en el pool para proporcionar liquidez.  
✅ **Intercambiar tokens:** Los usuarios pueden intercambiar uno de los tokens por el otro utilizando el pool de liquidez.  
✅ **Retirar liquidez:** El owner puede retirar sus participaciones en el pool.

---

## 🎯 Requisitos del proyecto
- Crear dos tokens ERC-20 simples, denominados obligatoriamente:
  - `TokenA`
  - `TokenB`
- Implementar un contrato de exchange llamado obligatoriamente `SimpleDEX` que:
  - Mantenga un pool de liquidez para TokenA y TokenB.
  - Utilice la fórmula del producto constante `(x+dx)(y-dy)=xy` para calcular los precios de intercambio.
  - Permita añadir y retirar liquidez.
  - Permita intercambiar TokenA por TokenB y viceversa.
- El contrato `SimpleDEX` debe incluir obligatoriamente las siguientes funciones:

- constructor(address _tokenA, address _tokenB)
- addLiquidity(uint256 amountA, uint256 amountB)
- swapAforB(uint256 amountAIn)
- swapBforA(uint256 amountBIn)
- removeLiquidity(uint256 amountA, uint256 amountB)
- getPrice(address _token)

---

## 🎓 Objetivos de Aprendizaje
- Comprender cómo funcionan los exchanges descentralizados y los pools de liquidez.
- Practicar la creación de tokens ERC-20 en Solidity.
- Implementar mecanismos simples de mercado automatizado (AMM).
- Llamar a otros contratos inteligentes desde Solidity.

---