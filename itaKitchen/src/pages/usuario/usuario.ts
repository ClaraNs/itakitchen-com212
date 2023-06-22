import { Component } from '@angular/core';
import { AlertController, IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { Storage } from '@ionic/storage';
import { EditarClientePage } from '../editar-cliente/editar-cliente';
import { MinhasAvaliacoesPage } from '../minhas-avaliacoes/minhas-avaliacoes';
import { InicioPage } from '../inicio/inicio';
import { NovaAvaliacaoPage } from '../nova-avaliacao/nova-avaliacao';
import { RelatoriosPage } from '../relatorios/relatorios';
import { EditarEstabPage } from '../editar-estab/editar-estab';
import { EditarEnderecoPage } from '../editar-endereco/editar-endereco';
import { EditarHorarioPage } from '../editar-horario/editar-horario';
/**
 * Generated class for the UsuarioPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-usuario',
  templateUrl: 'usuario.html',
})
export class UsuarioPage {

  usuario: any = null;
  imagemURL: any = null;
  numavaliacoes: any = 0;
  clienteOuEstab: any = 0; // 0 - cliente 1 - estabelecimento

  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService,
    private alertCtrl: AlertController, private toastCtrl: ToastController, public storage: Storage) {
    this.usuario = this.navParams.get("usuario");
    this.imagemURL = 'data:image/png;base64,' + this.usuario.foto;
    if (this.usuario.cnpj != undefined) {
      this.clienteOuEstab = 1;
    }
    this.retornaNumAvaliacoes();
  }


  editarEstab() {
    this.share.retornaEstabelecimentoPorID(this.usuario.id).subscribe((data: any) => {
      let estab = {
        id: data[0].id,
        email: data[0].email,
        nome: data[0].nome,
        cnpj: data[0].cnpj,
        descricao: data[0].descricao,
        contato: data[0].contato,
        foto: data[0].foto,
        idendereco: data[0].idEndereco,
        idhorariofunc: data[0].idHorario,
        idcategoria: data[0].idCategoria,
      };

      this.navCtrl.push(EditarEstabPage, { estab: estab }, { animate: true });
    });

  }

  editarEndereco() {
    this.share.retornaEndereco(this.usuario.idendereco).subscribe((data4: any) => {
      let x = data4[0];
      let endereco = {
        id: x.id,
        rua: x.rua,
        bairro: x.bairro,
        numero: x.numero,
        cep: x.cep,
        complemento: x.complem,
        textocep: x.cep.slice(0, 5) + '-' + x.cep.slice(5),
      }
      this.navCtrl.push(EditarEnderecoPage, { endereco: endereco }, { animate: true });
    });



  }

  editarHorario() {
    this.share.retornaHorario(this.usuario.idhorariofunc).subscribe((data3: any) => {
      let y = data3[0];
      let horario = {
        id: y.id,
        hdomingoinicio: this.formataHora(y.hDomingoInicio),
        hdomingofim: this.formataHora(y.hDomingoFim),
        hsegundainicio: this.formataHora(y.hSegundaInicio),
        hsegundafim: this.formataHora(y.hSegundaFim),
        htercainicio: this.formataHora(y.hTercaInicio),
        htercafim: this.formataHora(y.hTercaFim),
        hquartainicio: this.formataHora(y.hQuartaInicio),
        hquartafim: this.formataHora(y.hQuartaFim),
        hquintainicio: this.formataHora(y.hQuintaInicio),
        hquintafim: this.formataHora(y.hQuintaFim),
        hsextainicio: this.formataHora(y.hSextaInicio),
        hsextafim: this.formataHora(y.hSextaFim),
        hsabadoinicio: this.formataHora(y.hSabadoInicio),
        hsabadofim: this.formataHora(y.hSabadoFim)
      }

      this.navCtrl.push(EditarHorarioPage, { horario: horario }, { animate: true });
    });

  }

  formataHora(hora){
    return hora.slice(0,2) + ':' + hora.slice(3, 5);
  }

  verDiagnosticos() {
    this.navCtrl.push(RelatoriosPage, {}, { animate: true });
  }

  novaAvaliacao() {
    this.navCtrl.push(NovaAvaliacaoPage, { usuario: this.usuario });
  }

  minhasAvaliacoes() {
    this.navCtrl.push(MinhasAvaliacoesPage, { usuario: this.usuario, clienteOuEstab: this.clienteOuEstab },
      { animate: true });
  }


  editarPerfil() {
    if (this.usuario.cpf != undefined) {
      this.navCtrl.push(EditarClientePage, { usuario: this.usuario }, { animate: true });
    } else {

    }
  }

  retornaNumAvaliacoes() {
    if (this.usuario.cpf != undefined) {
      this.share.retornaNumAvaliacoes(this.usuario.id).subscribe((data: any) => {
        this.numavaliacoes = data[0];
      });
    } else {
      this.share.retornaNumAvaliacoesPorEstab(this.usuario.id).subscribe((data: any) => {
        this.numavaliacoes = data[0][0];
      });
    }
  }

  sair() {
    this.navCtrl.pop();
    this.navCtrl.pop();
  }

  inicio() {
    this.navCtrl.push(InicioPage, { usuario: this.usuario }, { animate: true });
  }

  confirmaExclusao() {
    const confirm = this.alertCtrl.create({
      title: 'Excluir Usuário',
      message: 'Deseja mesmo excluir seu cadastro? Ficamos tristes com sua partida...',
      buttons: [
        {
          text: 'Não',
          handler: () => {

          }
        },
        {
          text: 'Sim',
          handler: () => {
            this.deletaUsuario();
          }
        }
      ]
    });
    confirm.present();
  }

  deletaUsuario() {
    if (this.usuario.cpf != undefined) {
      this.share.excluirUsuario(this.usuario.id).subscribe(async (data: any) => {
        if (data == 1) {
          let toast = this.toastCtrl.create({
            message: "Usuário deletado com sucesso!",
            duration: 2000
          });
          toast.present();
          await this.storage.clear();
          this.sair();

        }
      });

    } else {
      this.share.excluirEstab(this.usuario.id).subscribe(async (data: any) => {
        if (data == 1) {
          let toast = this.toastCtrl.create({
            message: "Usuário deletado com sucesso!",
            duration: 2000
          });
          toast.present();
          await this.storage.clear();
          this.sair();

        }
      });
    }
  }

}
