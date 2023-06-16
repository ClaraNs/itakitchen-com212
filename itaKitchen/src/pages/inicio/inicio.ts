import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { UsuarioPage } from '../usuario/usuario';
import { MinhasAvaliacoesPage } from '../minhas-avaliacoes/minhas-avaliacoes';
import { ShareService } from '../share/share';

/**
 * Generated class for the InicioPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-inicio',
  templateUrl: 'inicio.html',
})
export class InicioPage {

  clienteOuEstab: any = 0; //0 Cliente - 1 Estabelecimento 
  usuario: any;
  estabelecimentos: any = [];
  avaliacoes:any = [];

  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService) {
    
    this.usuario = this.navParams.get("usuario");
    if (this.usuario.cpf != undefined) {
      this.clienteOuEstab = 0;
      this.carregarEstabelecimentos();
    }else{
      this.clienteOuEstab = 1;
    }
  }

  acessarPerfil() {
    this.navCtrl.push(UsuarioPage, { usuario: this.usuario, clienteOuEstab: this.clienteOuEstab },
      { animate: true });
  }

  minhasAvaliacoes() {
    this.navCtrl.push(MinhasAvaliacoesPage, { usuario: this.usuario, clienteOuEstab: this.clienteOuEstab },
      { animate: true });
  }

  sair() {
    this.navCtrl.pop();
  }

  carregarEstabelecimentos() {
    this.share.retornaEstab().subscribe((data: any) => {
      this.estabelecimentos = [];
      data.forEach(x => {
        this.share.retornaNumAvaliacoesPorEstab(x.id).subscribe((data2: any) => {
          let estab = {
            id: x.id,
            nome: x.nome,
            cnpj: x.cnpj,
            contato: x.contato,
            foto: x.foto,
            idendereco: x.idendereco,
            idhorariofunc: x.idhorariofunc,
            idcategoria: x.categoria,
            tipoarquivo: 'jpeg',
            numavaliacoes: data2[0][0],
            nota: data2[0][1],
            fotourl: 'data:image/' + 'png' + ';base64,' + x.foto
          }

          this.estabelecimentos.push(estab);
        });
      });
    })
  }



}
