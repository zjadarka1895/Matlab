import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def wczytaj_dane_z_pliku(nazwa_pliku="chelm.txt"):
    try:
        df = pd.read_csv(nazwa_pliku, sep='\t', header=None, names=["Odległość", "Wysokość"])
        return df
    except FileNotFoundError:
        print(f"Błąd: Plik '{nazwa_pliku}' nie został znaleziony.")
        return None

def rozwiaz_splajn_naturalny_macierzowo(x, y):
    """
    zwraca tablicę drugich pochodnych (M_i) dla każdego węzła.
    """
    n = len(x)
    if n < 2:
        raise ValueError("Potrzeba co najmniej 2 punktów.")
    if n == 2:
        return np.zeros(n)  # Splajn liniowy

    h = np.diff(x)
    A = np.zeros((n, n))
    B = np.zeros(n)

    A[0, 0], A[-1, -1] = 1, 1  # Warunki naturalne
    for i in range(1, n - 1):
        A[i, i - 1] = h[i - 1]
        A[i, i] = 2 * (h[i - 1] + h[i])
        A[i, i + 1] = h[i]
        B[i] = 6 * ((y[i + 1] - y[i]) / h[i] - (y[i] - y[i - 1]) / h[i - 1])

    return np.linalg.solve(A, B)


def oblicz_wspolczynniki_splajnu(x, y, M):
    """
    oblicza współczynniki (a, b, c, d) dla każdego segmentu splajnu.
    """
    h = np.diff(x)
    splajny = []

    for i in range(len(x) - 1):
        hi = h[i]
        a = y[i]
        b = (y[i + 1] - y[i]) / hi - hi * (2 * M[i] + M[i + 1]) / 6
        c = M[i] / 2
        d = (M[i + 1] - M[i]) / (6 * hi)
        splajny.append((a, b, c, d, x[i]))

    return splajny


def ewaluuj_splajn(splajny, x_data, x_eval):
    """
    Oblicza wartości splajnu dla podanych punktów x_eval.
    """
    y_eval = np.zeros_like(x_eval, dtype=float)
    indices = np.searchsorted(x_data, x_eval) - 1
    indices = np.clip(indices, 0, len(splajny) - 1)

    for i, x_val in enumerate(x_eval):
        a, b, c, d, xi = splajny[indices[i]]
        dx = x_val - xi
        y_eval[i] = a + b * dx + c * dx**2 + d * dx**3

    return y_eval


def rysuj_wykres(x_dane, y_dane, x_punkty, y_punkty, x_interp, y_interp, tytul):
    """
    Rysuje dane, punkty oraz krzywą splajnu.
    """
    plt.figure(figsize=(12, 6))
    plt.plot(x_dane, y_dane, label="Dane wejściowe", color='dodgerblue', linewidth=1.5)
    plt.plot(x_interp, y_interp, label="Interpolacja Splajnem", color='red', linewidth=1.5)
    plt.scatter(x_punkty, y_punkty, color='crimson', s=15, zorder=5,
                label="Wybrane punkty", edgecolors='black', linewidth=0.8)

    plt.title(tytul)
    plt.xlabel("Odległość [m]")
    plt.ylabel("Wysokość [m]")
    plt.yscale('log')
    plt.legend()
    plt.grid(True, which="both", ls="-", alpha=0.6)
    plt.tight_layout()
    plt.show()


# --- Główna część programu ---
if __name__ == "__main__":
    dane = wczytaj_dane_z_pliku("przyk3.txt")
    if dane is not None:
        x = dane["Odległość"].values
        y = dane["Wysokość"].values

        # Wybór n równomiernie rozłożonych punktów
        n = 100
        idx = np.linspace(0, len(x) - 1, n, dtype=int)
        x_wybrane = x[idx]
        y_wybrane = y[idx]

        M = rozwiaz_splajn_naturalny_macierzowo(x_wybrane, y_wybrane)
        splajny = oblicz_wspolczynniki_splajnu(x_wybrane, y_wybrane, M)

        x_interp = np.linspace(x_wybrane[0], x_wybrane[-1], 512)
        y_interp = ewaluuj_splajn(splajny, x_wybrane, x_interp)

        rysuj_wykres(x_dane=x, y_dane=y,
                     x_punkty=x_wybrane, y_punkty=y_wybrane,
                     x_interp=x_interp, y_interp=y_interp,
                     tytul=f"Funcja o wielu łagodnych wzniesieniach - Interpolacja splajnem ({len(x_wybrane)} punktów)")
