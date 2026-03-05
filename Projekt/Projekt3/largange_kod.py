import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


def wczytaj_dane_z_pliku(plik_txt):
    df = pd.read_csv(plik_txt, delim_whitespace=True, header=None, names=["Odległość", "Wysokość"])
    print(f"Łączna liczba punktów w pliku: {len(df)}")
    return df


def lagrange_interpolacja_punkt(x_punkty, y_punkty, x):
    #wartość wielomianu interpolacyjnego Lagrange'a dla pojedynczego x
    n = len(x_punkty)
    wynik = 0.0
    for i in range(n):
        li = 1.0
        for j in range(n):
            if i != j:
                li *= (x - x_punkty[j]) / (x_punkty[i] - x_punkty[j])
        wynik += y_punkty[i] * li
    return wynik


def skaluj_do_minus1_1(x, a, b):
    if b == a:
        return 0
    return 2 * (x - a) / (b - a) - 1


def deskaluj_z_minus1_1(x_skalowane, a, b):
    return (x_skalowane + 1) * (b - a) / 2 + a


def wybierz_punkty_rowno_rozlozone(x_dane, y_dane, n):
    if n > len(x_dane):
        raise ValueError("Liczba punktów n nie może być większa niż długość danych wejściowych.")

    indeksy = np.linspace(0, len(x_dane) - 1, n, dtype=int)
    x_wybrane = x_dane[indeksy]
    y_wybrane = y_dane[indeksy]

    return x_wybrane, y_wybrane


def oblicz_krzywa_lagrange(x_wybrane_oryg, y_wybrane_oryg, a_full_range, b_full_range, liczba_punktow=500):
    a_interp = x_wybrane_oryg.min()
    b_interp = x_wybrane_oryg.max()

    # Skalowanie do dziedziny [-1, 1]
    x_wybrane_skalowane = np.array([skaluj_do_minus1_1(xi, a_interp, b_interp) for xi in x_wybrane_oryg])

    start_skalowane = skaluj_do_minus1_1(a_full_range, a_interp, b_interp) if b_interp != a_interp else -1.0
    end_skalowane = skaluj_do_minus1_1(b_full_range, a_interp, b_interp) if b_interp != a_interp else 1.0

    x_interp_skalowane_full_range = np.linspace(start_skalowane,
                                                end_skalowane,
                                                liczba_punktow)

    # obliczanie y interpolacji Lagrange'a dla każdego punktu
    y_interp_skalowane = [lagrange_interpolacja_punkt(x_wybrane_skalowane, y_wybrane_oryg, x)
                          for x in x_interp_skalowane_full_range]

    # deskalowanie punktów x dla wykresu z powrotem do oryginalnego przedziału
    x_interp_oryg = np.array([deskaluj_z_minus1_1(xi_skalowane, a_interp, b_interp)
                              for xi_skalowane in x_interp_skalowane_full_range])

    return x_interp_oryg, np.array(y_interp_skalowane)  # Zwracamy numpy array dla y


def rysuj_wykres(x_dane_wejsciowe, y_dane_wejsciowe,
                 x_wybrane_punkty, y_wybrane_punkty,
                 x_interp_oryg, y_interp_oryg, tytul):

    plt.figure(figsize=(12, 6))

    # wykres danych wejściowych
    plt.plot(x_dane_wejsciowe, y_dane_wejsciowe, label="Dane wejściowe", color='dodgerblue', linewidth=1.5)
    #chelm - 'green'
    #tczew -
    # Wykres interpolacji Lagrange'a
    y_interp_positive = np.where(y_interp_oryg > 0, y_interp_oryg, np.nan)
    plt.plot(x_interp_oryg, y_interp_positive, label="Interpolacja Lagrange’a", color='orange', linewidth=1.5)

    # Wykres wybranych punktów
    plt.scatter(x_wybrane_punkty, y_wybrane_punkty, color='crimson', s=30, zorder=5, label="Wybrane punkty",
                edgecolors='black', linewidth=0.8)

    plt.title(tytul)
    plt.xlabel("Odległość [m]")
    plt.ylabel("Wysokość [m]")
    plt.yscale('log')  # Ustawienie skali logarytmicznej na osi Y

    plt.legend()
    plt.grid(True, which="both", ls="-", alpha=0.6)
    plt.tight_layout()
    plt.show()


# --- Główna część programu (main) ---
if __name__ == "__main__":
    plik_danych = "tczew_starogard.txt"
    liczba_punktow_do_interpolacji = 20  # Ustawiamy liczbę punktów do interpolacji na 5

    # 1. Wczytanie danych
    dane = wczytaj_dane_z_pliku(plik_danych)
    x_dane_wejsciowe = dane['Odległość'].values
    y_dane_wejsciowe = dane['Wysokość'].values

    a_original_full_range = x_dane_wejsciowe.min()
    b_original_full_range = x_dane_wejsciowe.max()

    x_do_interpolacji, y_do_interpolacji = wybierz_punkty_rowno_rozlozone(
        x_dane_wejsciowe, y_dane_wejsciowe, liczba_punktow_do_interpolacji
    )
    # obliczenie punktów krzywej interpolacji Lagrange'a
    x_interpolated_lagrange, y_interpolated_lagrange = oblicz_krzywa_lagrange(
        x_do_interpolacji, y_do_interpolacji,
        a_original_full_range, b_original_full_range,
        liczba_punktow=512
    )

    # 4. Rysowanie wykresu
    rysuj_wykres(x_dane_wejsciowe, y_dane_wejsciowe,
                 x_do_interpolacji, y_do_interpolacji,
                 x_interpolated_lagrange, y_interpolated_lagrange,
                 f"Tczew-Starogard Gdański - Interpolacja Lagrange’a ({len(x_do_interpolacji)} punktów)")