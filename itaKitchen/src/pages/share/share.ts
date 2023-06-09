import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import 'rxjs/add/operator/map';

@Injectable()
export class ShareService {

    inicioURL: string = 'http://localhost:8000/';

    constructor(public http: HttpClient) {

    }

    verificaLogin(email, senha) {
        var url = this.inicioURL + 'login';
        var body = {
            "email": email,
            "senha": senha
        };

        return this.http.post(url, body).map(res => res);


    }

    cadastrarCliente(email, senha, nome, cpf, datanas, foto, tipo) {
        var url = this.inicioURL + 'criarcliente';
        var body = {
            "email": email,
            "senha": senha,
            "nome": nome,
            "cpf": cpf,
            "datanas": datanas,
            "foto": foto,
            "tipo": tipo
        };

        return this.http.post(url, body).map(res => res);


    }
}