# uvoz potrebnih biblioteka na vrhu fajla
import os
from logging import debug
from re import escape, split
from flask import Flask, render_template, session, url_for, request, redirect
from werkzeug.security import generate_password_hash, check_password_hash
from flask_mail import Mail, Message

import ast
import mysql.connector
import mariadb
import io
import csv

from werkzeug.wrappers import response

# konekcija sa bazom
konekcija = mysql.connector.connect(
    passwd = "root", #lozinka za bazu
    user = "root", #korisnicko ime
    database = "evidencijaigraca", #ime baze
    port = 3306 , #port msql servera 
    auth_plugin = 'mysql_native_password'
)
kursor = konekcija.cursor(dictionary=True)

# deklaracija Flask aplikacije ispod “import-a”
app = Flask(__name__)
app.secret_key = "poggers123"


# logika aplikacije
# login
def ulogovan():
    if "ulogovani_skaut" in session:
        return True
    else:
        return False


def rola():
    if ulogovan():
        return ast.literal_eval(session["ulogovani_skaut"]).pop("rola")

#login
@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "GET":
        return render_template("login.html")

    if request.method == "POST":
        forma = request.form
        upit = "SELECT * FROM skauti WHERE email = %s"
        vrednost = (forma["email"],)
        kursor.execute(upit, vrednost)
        skaut = kursor.fetchone()

        if skaut != None:
            if skaut["lozinka"] == forma["lozinka"]:
                session["ulogovani_skaut"] = str(skaut)
                return redirect(url_for("render_skauti"))
            else:
                return render_template("login.html")

        else:
            return render_template("login.html")
        
# logout
@app.route("/logout", methods=["GET"])
def logout():
    session.pop('ulogovani_skaut', None)
    return render_template("login.html")

# rute
@app.route('/skauti', methods=['GET'])
def render_skauti():
    if ulogovan():
        upit = "SELECT * FROM skauti LIMIT 10 OFFSET %s"

        strana = request.args.get("page", "1")

        offset = int(strana) * 10 - 10
        prethodna_strana = ""
        sledeca_strana = "/skauti?page=2"

        if "=" in request.full_path:
            split_path = request.full_path.split("=")
            del split_path[-1]
            sledeca_strana = "=".join(split_path) + "=" + str(int(strana) + 1)
            prethodna_strana = "=".join(
                split_path) + "=" + str(int(strana) - 1)

        vrednost = (offset,)
        kursor.execute(upit, vrednost)
        skauti = kursor.fetchall()

        # ✔️
        return render_template("skauti.html",  skauti=skauti, sledeca_strana=sledeca_strana, prethodna_strana=prethodna_strana, strana=strana)

    else:
        return redirect(url_for("login"))
@app.route('/igraci', methods=['GET'])
def render_igraci():
    if ulogovan():

        upit = "SELECT * FROM igraci i, timovi t WHERE t.Id = i.TimID;"
        kursor.execute(upit)
        igraci = kursor.fetchall()

        return render_template("igraci.html", igraci=igraci)

@app.route('/timovi', methods=['GET'])
def render_timovi():
    if ulogovan():

        upit = "SELECT * FROM timovi"
        kursor.execute(upit)
        timovi = kursor.fetchall()

        return render_template("timovi.html", timovi=timovi)

    else:
        return redirect(url_for("login"))
    
@app.route("/dodajIgraca", methods=["GET", "POST"])
def render_dodajIgraca():
    if ulogovan():
        if request.method == "GET":
            return render_template("dodajIgraca.html")

        if request.method == "POST":
            forma = request.form
            vrednosti = (
                forma["ImeInput"],
                forma["PrezimeInput"],
                forma["GodinaRodjenjaInput"],
                forma["BrojDresaInput"],
                forma["ProsecanBrojPoenaInput"],
                forma["AgentIDInput"],
                forma["TimIDInput"],
            )

            upit = "INSERT INTO igraci (Ime, Prezime, GodinaRodjenja, BrojDresa, ProsecanBrojPoena, AgentID, TimID) VALUES(%s, %s, %s, %s, %s, %s, %s)"

            kursor.execute(upit, vrednosti)
            konekcija.commit()

            return redirect(url_for("render_igraci"))
    else:
        return redirect(url_for("login"))
@app.route('/dodajSkauta', methods=['GET', 'POST'])
def render_dodajSkauta():
    return render_template('dodajSkauta.html')
@app.route('/izmeniSkauta', methods=['GET', 'POST'])
def render_izmeniSkauta():
    return render_template('izmeniSkauta.html')
@app.route('/izmeniIgraca', methods=['GET', 'POST'])
def render_izmeniIgraca():
    return render_template('izmeniIgraca.html')
@app.route('/izmeniTim', methods=['GET', 'POST'])
def render_izmeniTim():
    return render_template('izmeniTim.html')
@app.route("/izbriSkauta/<id>", methods=["POST"])
def render_izbrisiSkauta(id):

    if ulogovan():

        upit = "DELETE FROM skauti WHERE ID = %s"

        vrednost = (id,)
        kursor.execute(upit, vrednost)
        konekcija.commit()
        return redirect(url_for("render_skauti"))

    else:
        return redirect(url_for("login"))
@app.route("/izbriTim/<id>", methods=["POST"])
def render_izbrisiTim(id):

    if ulogovan():

        upit = "DELETE FROM timovi WHERE ID = %s"

        vrednost = (id,)
        kursor.execute(upit, vrednost)
        konekcija.commit()
        return redirect(url_for("render_timovi"))

    else:
        return redirect(url_for("login"))
@app.route("/izbrisiIgraca/<id>", methods=["POST"])
def render_izbrisiIgraca(id):

    if ulogovan():

        upit = "DELETE FROM igraci WHERE id = %s"

        vrednost = (id,)
        kursor.execute(upit, vrednost)
        konekcija.commit()
        return redirect(url_for("render_igraci"))

    else:
        return redirect(url_for("login"))
@app.route('/pregledIgraca/<id>', methods=['GET'])
def render_pregledIgraca(id):
    if ulogovan():
        if request.method == "GET":
                igracUpit = "SELECT * FROM igraci i, timovi t WHERE i.ID = %s AND t.ID = i.TimID;"
                vrednost = (id,)

                kursor.execute(igracUpit, vrednost)
                igrac = kursor.fetchone()

                skautUpit = "SELECT s.Agencija FROM igraci i JOIN skauti s ON i.AgentID = s.ID WHERE i.ID = %s;"
                vrednost = (id,)
                kursor.execute(skautUpit, vrednost)
                skaut = kursor.fetchone()
                return render_template("pregledIgraca.html",  igrac=igrac, skaut=skaut)
    else:
        return redirect(url_for("login"))

app.run(debug=True)
