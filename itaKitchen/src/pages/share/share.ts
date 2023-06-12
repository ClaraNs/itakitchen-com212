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

    retornaNumAvaliacoes(idcli) {
        var url = this.inicioURL + 'numavaliacoescliente&id=' + idcli;
        return this.http.get(url).map(res => res);
    }

    excluirUsuario(idcli) {
        var url = this.inicioURL + 'deletacliente&id=' + idcli;
        return this.http.delete(url).map(res => res);
    }

    excluirEstab(idestab) {
        var url = this.inicioURL + 'deletaestabelecimento&id=' + idestab;
        return this.http.delete(url).map(res => res);
    }

    editarCliente(idcli, campos, valores) {
        var url = this.inicioURL + 'atualizacliente&id=' + idcli;
        var body = {
            "idcli": idcli,
            "campos": campos,
            "valores": valores
        }
        return this.http.put(url + "&campos=" + campos + "&valores=" + valores, body).map(res => res);
    }

    retornaEstab() {
        var url = this.inicioURL + 'estabelecimento';
        return this.http.get(url).map(res => res);
    }

    retornaNumAvaliacoesPorEstab(idestab) {
        var url = this.inicioURL + 'numavaliacaoporestab&id=' + idestab;
        return this.http.get(url).map(res => res);
    }

    retornaCategorias() {
        var url = this.inicioURL + 'categoria';
        return this.http.get(url).map(res => res);
    }

    verificarCep(cep) {
        const url = `https://viacep.com.br/ws/${cep}/json/`;
        return this.http.get(url);
    }

    cadastrarEstabelecimento(estab){
        var url = this.inicioURL + 'criarestabelecimento';
        var body = {
            "email": estab.email,
            "senha": estab.senha,
            "nome": estab.nome,
            "cnpj": estab.cnpj,
            "contato": estab.contato,
            "foto": estab.foto,
            "categoria": estab.categoria,
            "descricao": estab.descricao,
            "rua": estab.rua,
            "numero": estab.numero,
            "complem": estab.complemento,
            "bairro": estab.bairro,
            "cep": estab.cep,
            "hdomingoinicio": estab.hdomingoinicio,
            "hdomingofim": estab.hdomingofim,
            "hsegundainicio": estab.hsegundainicio,
            "hsegundafim": estab.hsegundafim,
            "htercainicio": estab.htercainicio,
            "htercafim": estab.htercafim,
            "hquartainicio": estab.hquartainicio,
            "hquartafim": estab.hquartafim,
            "hquintainicio": estab.hquintainicio,
            "hquintafim": estab.hquintafim,
            "hsextainicio": estab.hsextainicio,
            "hsextafim": estab.hsextafim,
            "hsabadoinicio": estab.hsabadoinicio,
            "hsabadofim": estab.hsabadofim

        };

        return this.http.post(url, body).map(res => res);

    }

    d
}